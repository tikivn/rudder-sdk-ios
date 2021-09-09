//
//  API+Headers.swift
//  Rudder
//
//  Created by Pallab Maiti on 05/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

extension API {
    var headers: [String: String]? {
        var headers = ["Content-Type": "Application/json"]
        switch self {
        case .downloadConfig:
            headers["Authorization"] = "Basic \(RSClient.shared.eventManager.authToken ?? "")"
        default:
            break
        }
        return headers
    }
}
