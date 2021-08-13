//
//  RSEventRepository.swift
//  Rudder
//
//  Created by Pallab Maiti on 10/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

class RSEventRepository {
    private let databaseManager = RSDatabaseManager()
    private let serverConfigManager = RSServerConfigManager()
    private let serviceManager = ServiceManager()

    private var options: RSOption?
    private var authToken: String?
    private var config: RSConfig?
    
    let cachedContext = RSContext()
    
    func configure(writeKey: String, config: RSConfig, options: RSOption) {
        self.authToken = writeKey.data(using: .utf8)?.base64EncodedString()
        self.config = config
        self.options = options
        RSClient.shared.logger.logDebug(message: "EventRepository: writeKey: \(writeKey)")
        RSClient.shared.logger.logDebug(message: "EventRepository: authToken: \(authToken ?? "")")
        RSClient.shared.logger.logDebug(message: "EventRepository: initiating element cache")
        
    }
}
