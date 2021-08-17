//
//  RSServerDestination.swift
//  Rudder
//
//  Created by Pallab Maiti on 17/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

struct RSServerDestination: Codable {
    private let _destinationId: String?
    var destinationId: String {
        return _destinationId ?? ""
    }

    private let _destinationName: String?
    var destinationName: String {
        return _destinationName ?? ""
    }

    private let _isDestinationEnabled: Bool?
    var isDestinationEnabled: Bool {
        return _isDestinationEnabled ?? false
    }

    private let _updatedAt: String?
    var updatedAt: String {
        return _updatedAt ?? ""
    }

    let destinationDefinition: RSServerDestinationDefinition?
    // let destinationConfig: [String: Any]

    enum CodingKeys: String, CodingKey {
        case _destinationId = "id"
        case _destinationName = "name"
        case _isDestinationEnabled = "enabled"
        case _updatedAt = "updatedAt"
        case destinationDefinition = "destinationDefinition"
    }
}
