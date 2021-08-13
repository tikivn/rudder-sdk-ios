//
//  RSLogger.swift
//  Rudder
//
//  Created by Pallab Maiti on 12/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

class RSLogger {
    
    var logLevel: RSLogLevel
    
    init() {
        logLevel = .error
    }
    
    func configure(logLevel: RSLogLevel) {
        self.logLevel = logLevel
    }
    
    func logVerbose(message: String) {
        if logLevel == .verbose {
            print("\(Constants.TAG):Verbose:\(message)")
        }
    }
    
    func logDebug(message: String) {
        if logLevel == .debug {
            print("\(Constants.TAG):Debug:\(message)")
        }
    }
    
    func logInfo(message: String) {
        if logLevel == .info {
            print("\(Constants.TAG):Info:\(message)")
        }
    }
    
    func logWarn(message: String) {
        if logLevel == .warning {
            print("\(Constants.TAG):Warn:\(message)")
        }
    }
    
    func logError(message: String) {
        if logLevel == .error {
            print("\(Constants.TAG):Error:\(message)")
        }
    }
}
