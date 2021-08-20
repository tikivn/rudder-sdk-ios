//
//  API.swift
//  Rudder
//
//  Created by Pallab Maiti on 05/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

enum API {
    case flushEvents
    case downloadConfig
}

enum APIClientStatus {
    case success
    case failure
    case serverFailure
    case unknown
    
    init(_ statusCode: Int) {
        switch statusCode {
        case 200..<300:
            self = .success
        case 400..<500:
            self = .failure
        case 500..<600:
            self = .serverFailure
        default:
            self = .unknown
        }
    }
}

extension API {
    var baseURL: String {
        switch self {
        case .flushEvents:
            return "\(RSClient.shared.eventRepository.config?.dataPlaneUrl ?? "")/\(version)/"
        case .downloadConfig:
            if RSClient.shared.eventRepository.config?.controlPlaneUrl.hasSuffix("/") == true {
                return "\(RSClient.shared.eventRepository.config?.controlPlaneUrl ?? "")"
            } else {
                return "\(RSClient.shared.eventRepository.config?.controlPlaneUrl ?? "")/"
            }
        }
    }
    
    var version: String {
        return "v1"
    }
}