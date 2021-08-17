//
//  RSServerDestinationDefinition.swift
//  Rudder
//
//  Created by Pallab Maiti on 17/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

struct RSServerDestinationDefinition: Codable {
    private let _definitionName: String?
    var definitionName: String {
        return _definitionName ?? ""
    }
    
    private let _displayName: String?
    var displayName: String {
        return _displayName ?? ""
    }
    
    private let _updatedAt: String?
    var updatedAt: String {
        return _updatedAt ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case _definitionName = "name"
        case _displayName = "displayName"
        case _updatedAt = "updatedAt"
    }
}
