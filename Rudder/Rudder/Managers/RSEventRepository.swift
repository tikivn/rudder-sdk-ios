//
//  RSEventRepository.swift
//  Rudder
//
//  Created by Pallab Maiti on 10/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

class RSEventRepository {
//    static let shared = RSEventRepository()
    let databaseManager: RSDatabaseManager?
    let serverConfigManager: RSServerConfigManager?
    
    init(writeKey: String, config: RSConfig) {
        databaseManager = RSDatabaseManager()
        serverConfigManager = RSServerConfigManager()
    }
}
