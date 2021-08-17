//
//  RSContext.swift
//  Rudder
//
//  Created by Pallab Maiti on 05/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

@objc open class RSContext: NSObject {
    var app: RSApp
    var traits: RSTraits?
    var library: RSLibraryInfo
    var osInfo: RSOSInfo
    var screenInfo: RSScreenInfo
    var userAgent: String?
    var locale: String
    var device: RSDeviceInfo
    var network: RSNetwork
    var timezone: String
    var externalIds: [[String: Any]]?

    override init() {
        self.app = RSApp()
        self.device = RSDeviceInfo()
        self.library = RSLibraryInfo()
        self.osInfo = RSOSInfo()
        self.screenInfo = RSScreenInfo()
        self.userAgent = RSUtils.userAgent()
        self.locale = RSUtils.getLocale()
        self.network = RSNetwork()
        self.timezone = NSTimeZone.local.identifier

        self.externalIds = nil
        self.traits = nil

        if let traitsJson = UserDefaults.standard.traits {
            do {
                self.traits = try JSONDecoder().decode(RSTraits.self, from: Data(traitsJson.utf8))
            } catch {
                self.traits = RSContext.createAndPersistTraits()
            }
        } else {
            self.traits = RSContext.createAndPersistTraits()
        }

        let externalIdsJson: String? = UserDefaults.standard.externalIds
        if externalIdsJson != nil {
            do {
                if let serializedExternalIds = try JSONSerialization.jsonObject(with: Data(externalIdsJson!.utf8), options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] {
                    self.externalIds = serializedExternalIds
                }
            } catch { }
        }
    }

    static func createAndPersistTraits() -> RSTraits {
        var traits: RSTraits = RSTraits()
        traits.anonymousId = UserDefaults.standard.anonymousId
        persistTraits(traits)
        return traits
    }

    static func persistTraits(_ traits: RSTraits) {
        do {
            let traitsData = try JSONEncoder().encode(traits)
            UserDefaults.standard.traits = String(data: traitsData, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateTraits(_ traits: RSTraits) {
        var updatedTraits = traits
        updatedTraits.anonymousId = UserDefaults.standard.anonymousId
        self.traits = updatedTraits
    }

    func updateExternalIds(_ externalIds: [[String: Any]]) {
        self.externalIds = externalIds
        do {
            let externalIdData = try JSONSerialization.data(withJSONObject: self.externalIds!, options: .prettyPrinted)
            UserDefaults.standard.externalIds = String(data: externalIdData, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func dict() -> [String: Any] {
        var tempDict: [String: Any] = [:]
        tempDict["app"] = app.dict()
        tempDict["traits"] = traits
        tempDict["library"] = library.dict()
        tempDict["os"] = osInfo.dict()
        tempDict["screen"] = screenInfo.dict()
        if userAgent != nil {
            tempDict["userAgent"] = userAgent
        }
        tempDict["locale"] = locale
        tempDict["device"] = device.dict()
        tempDict["network"] = network.dict()
        tempDict["timezone"] = timezone
        tempDict["externalId"] = externalIds
        return tempDict
    }

    @objc public func putDeviceToken(_ deviceToken: String) {
        self.device.token = deviceToken
    }

    @objc public func putAdvertisementId(_ idfa: String) {
        // This isn't ideal.  We're doing this because we can't actually check if IDFA is enabled on
        // the customer device.  Apple docs and tests show that if it is disabled, one gets back all 0's.
        RSClient.shared.logger.logDebug(message: "IDFA: \(idfa)")
        let adTrackingEnabled: Bool = idfa == "00000000-0000-0000-0000-000000000000"
        self.device.adTrackingEnabled = adTrackingEnabled
        if adTrackingEnabled {
            self.device.advertisingId = idfa
        }
    }

    @objc public func putAppTrackingConsent(_ att: RSATT) {
        self.device.attTrackingStatus = att
}
}
