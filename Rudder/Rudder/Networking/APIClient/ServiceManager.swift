//
//  ServiceManager.swift
//  Rudder
//
//  Created by Pallab Maiti on 05/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

typealias Handler<T> = (HandlerResult<T, NSError>) -> Void

enum HandlerResult<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

struct ServiceManager: ServiceType {
    static let sharedSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: configuration)
    }()
    
    func downloadServerConfig(_ completion: @escaping Handler<RSServerConfig>) {
        ServiceManager.request(.downloadConfig, completion)
    }
}

extension ServiceManager {
    static func request<T: Codable>(_ API: API, _ completion: @escaping Handler<T>) {
        let urlString = [API.baseURL, API.path].joined().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString ?? "")!)
        request.httpMethod = API.method.value
        let dataTask = ServiceManager.sharedSession.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(NSError(code: .SERVER_ERROR)))
                    return
                }
                let response = response as? HTTPURLResponse
                if let statusCode = response?.statusCode {
                    let apiClientStatus = APIClientStatus(statusCode)
                    switch apiClientStatus {
                    case .success:
                        do {
                            let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                            print(json)
                            let object = try JSONDecoder().decode(T.self, from: data ?? Data())
                            print(object)
                            completion(.success(object))
                        } catch {
                            completion(.failure(NSError(code: .DECODING_FAILED)))
                        }
                    default:
                        let errorCode = handleCustomError(data: data ?? Data())
                        completion(.failure(NSError(code: errorCode)))
                    }
                } else {
                    completion(.failure(NSError(code: .SERVER_ERROR)))
                }
            }
        })
        dataTask.resume()
    }
    
    static func handleCustomError(data: Data) -> RSErrorCode {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                return .SERVER_ERROR
            }
            print(json)
            if let message = json["message"], message == "Invalid write key" {
                return .WRONG_WRITE_KEY
            }
            return .SERVER_ERROR
        } catch {
            return .SERVER_ERROR
        }
    }
}
