//
//  RSServerConfigManager.swift
//  Rudder
//
//  Created by Pallab Maiti on 10/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

class RSServerConfigManager {
    
    var serverConfig: RSServerConfig?
    var error: NSError?
    
    func fetchServerConfig() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.manageServerConfig()
            let myQueue = DispatchQueue(label: "com.ruder.RSServerConfigManager")
            myQueue.sync { [weak self] in
                self?.serverConfig = RSConstants.getServerConfig()
                if self?.serverConfig == nil {
                    
                }
            }
        }
    }
    
    func isServerConfigOutDated() -> Bool {
        let currentTime = RSUtils.getTimeStamp()
        if let lastUpdatedTime = RSConstants.getLastUpdatedTime(), let config = RSClient.shared.eventRepository.config {
            RSClient.shared.logger.logDebug(message: "Last updated config time: \(lastUpdatedTime)")
            RSClient.shared.logger.logDebug(message: "Current time: \(currentTime)")
            return (currentTime - lastUpdatedTime) > config.configRefreshInterval * 60 * 60 * 1000
        }
        return false
    }
}

extension RSServerConfigManager {
    private func manageServerConfig() {
        var retryCount = 0
        var isCompleted = false
        while isCompleted && retryCount < 4 {
            if let serverConfig = downloadServerConfig() {
                RSConstants.saveServerConfig(serverConfig)
                RSConstants.updateLastUpdatedTime(RSUtils.getTimeStamp())
                RSClient.shared.logger.logDebug(message: "server config download successful")
                isCompleted = true
            } else {
                if error?.code == RSErrorCode.WRONG_WRITE_KEY.rawValue {
                    RSClient.shared.logger.logDebug(message: "Wrong write key")
                    retryCount = 4
                } else {
                    RSClient.shared.logger.logDebug(message: "Retrying download in \(retryCount) seconds")
                    retryCount += 1
                    sleep(UInt32(retryCount))
                }
            }
        }
        if !isCompleted {
            RSClient.shared.logger.logDebug(message: "Server config download failed.Using last stored config from storage")
        }
    }
    
    private func downloadServerConfig() -> RSServerConfig? {
        var serverConfig: RSServerConfig?
        let semaphore = DispatchSemaphore(value: 0)
        RSClient.shared.eventRepository.serviceManager.downloadServerConfig { [weak self] result in
            switch result {
            case .success(let config):
                serverConfig = config
            case .failure(let error):
                self?.error = error
            }
            semaphore.signal()
        }
        semaphore.wait()
        return serverConfig
    }
}
