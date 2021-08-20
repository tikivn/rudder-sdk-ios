//
//  RSUtils.swift
//  Rudder
//
//  Created by Desu Sai Venkat on 06/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation
import WebKit

struct RSUtils {
    static func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: date)
    }
    
    static func getTimeStampString() -> String {
        return getDateString(date: Date())
    }

    static func getDBPath() -> String {
        let urlDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        let fileUrl = urlDirectory.appendingPathComponent("rl_persistence.sqlite")
        return fileUrl.path
    }

    static func getTimeStamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }

    static func getUniqueId() -> String {
        return NSUUID().uuidString.lowercased()
    }

    static func getLocale() -> String {
        let locale = Locale.current
        if #available(iOS 10.0, *) {
            return String(format: "%@-%@", locale.languageCode!, locale.regionCode!)
        }
        return "NA"
    }

    static func userAgent() -> String? {
        return WKWebView().value(forKey: "userAgent") as? String
    }
}