//
//  RSEventHandler.swift
//  Rudder
//
//  Created by Pallab Maiti on 10/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

class RSEventManager {
    var databaseManager: RSDatabaseManager?
    var serverConfigManager: RSServerConfigManager?
    private var appLifeCycleTrackingManager: RSTrackingManager?
    private var screenTrackingManager: RSTrackingManager?
    private var customFactoryManager = RSCustomFactoryManager()
    private var factoryManager = RSFactoryManager()
    private var processorManager = RSProcessorManager()
    
    let serviceManager = RSServiceManager()

    var options: RSOption?
    var writeKey: String?
    var authToken: String?
    var config: RSConfig?
    private var anonymousIdToken: String?
    var cachedContext: RSContext?
    var isSDKEnabled: Bool?
    var areFactoriesInitialized: Bool?
    var integrationOperationList = [RSIntegrationOperation]()
    var eventReplayMessageList = [RSMessage]()
    
    func configure(writeKey: String, config: RSConfig, options: RSOption) {
        self.writeKey = writeKey
        self.authToken = writeKey.computeAuthToken()
        self.config = config
        self.options = options
        
        areFactoriesInitialized = false
        isSDKEnabled = true
        
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
            appLifeCycleTrackingManager = RSAppLifeCycleTrackingManager()
            appLifeCycleTrackingManager?.track()
        }
        
        if config.recordScreenViews {
            RSClient.shared.logger.logDebug(message: "EventRepository: starting automatic screen records")
            screenTrackingManager = RSScreenTrackingManager()
            screenTrackingManager?.track()
        }
    }
    
    private func initializeSDK() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            var retryCount = 0
            var isInitialized = false
            while !isInitialized && retryCount < 6 {
                if let serverConfig = self.serverConfigManager?.serverConfig {
                    self.isSDKEnabled = serverConfig.enabled
                    if self.isSDKEnabled == true {
                        RSClient.shared.logger.logDebug(message: "EventRepository: initiating processor")
                        self.processorManager.initiateProcessor()
                        RSClient.shared.logger.logDebug(message: "EventRepository: initiating factories")
                        let factoryInput = RSFactoryManager.Input(serverConfig: serverConfig, config: self.config)
                        let factoryOutput = self.factoryManager.transform(input: factoryInput)
                        self.integrationOperationList.append(contentsOf: factoryOutput.integrationOperationList)
                        
                        RSClient.shared.logger.logDebug(message: "EventRepository: initiating custom factories")
                        let customFactoryInput = RSCustomFactoryManager.Input(serverConfig: serverConfig, config: self.config)
                        let customFactoryOutput = self.customFactoryManager.transform(input: customFactoryInput)
                        self.integrationOperationList.append(contentsOf: customFactoryOutput.integrationOperationList)
                        self.areFactoriesInitialized = true
                        self.replayMessageQueue()
                    } else {
                        RSClient.shared.logger.logDebug(message: "EventRepository: source is disabled in your Dashboard")
                        self.databaseManager?.clearAllEvents()
                    }
                    isInitialized = true
                } else if self.serverConfigManager?.error?.code == RSErrorCode.WRONG_WRITE_KEY.rawValue {
                    retryCount = 6
                    RSClient.shared.logger.logDebug(message: "Wrong write key")
                } else {
                    retryCount += 1
                    RSClient.shared.logger.logDebug(message: "server config is null. retrying in \(retryCount).")
                    sleep(UInt32(retryCount * 2))
                }
            }
        }
    }
    
    private func replayMessageQueue() {
        
    }
}
