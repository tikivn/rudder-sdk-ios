//
//  RSEventRepository.swift
//  Rudder
//
//  Created by Pallab Maiti on 10/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

class RSEventRepository {
    private var databaseManager: RSDatabaseManager?
    private var serverConfigManager: RSServerConfigManager?
    let serviceManager = ServiceManager()

    private var options: RSOption?
    var authToken: String?
    var config: RSConfig?
    private var anonymousIdToken: String?
    var cachedContext: RSContext?
    
    func configure(writeKey: String, config: RSConfig, options: RSOption) {
        self.authToken = writeKey.data(using: .utf8)?.base64EncodedString()
        self.config = config
        self.options = options
        RSClient.shared.logger.logDebug(message: "EventRepository: writeKey: \(writeKey)")
        RSClient.shared.logger.logDebug(message: "EventRepository: authToken: \(authToken ?? "")")
        RSClient.shared.logger.logDebug(message: "EventRepository: initiating element cache")
        cachedContext = RSContext()
        
        anonymousIdToken = UserDefaults.standard.anonymousId?.data(using: .utf8)?.base64EncodedString()
        RSClient.shared.logger.logDebug(message: "EventRepository: anonymousIdToken: \(anonymousIdToken ?? "")")
        
        RSClient.shared.logger.logDebug(message: "EventRepository: initiating DatabaseManager")
        databaseManager = RSDatabaseManager()
        
        RSClient.shared.logger.logDebug(message: "EventRepository: initiating ServerConfigManager")
        serverConfigManager = RSServerConfigManager()
        serverConfigManager?.fetchServerConfig()
        
        RSClient.shared.logger.logDebug(message: "EventRepository: initiating processor and factories")
        initializeSDK()
        
        if config.trackLifecycleEvents {
            RSClient.shared.logger.logDebug(message: "EventRepository: tracking application lifecycle")
            prepareApplicationLifeCycleTracking()
        }
        
        if config.recordScreenViews {
            RSClient.shared.logger.logDebug(message: "EventRepository: starting automatic screen records")
            prepareScreenTracking()
        }
    }
    
    private func initializeSDK() {
        
    }
    
    private func prepareApplicationLifeCycleTracking() {
        
    }
    
    private func prepareScreenTracking() {
        
    }
}
