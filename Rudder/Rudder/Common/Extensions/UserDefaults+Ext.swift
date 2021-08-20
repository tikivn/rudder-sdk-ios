//
//  UserDefaults+Ext.swift
//  Rudder
//
//  Created by Pallab Maiti on 13/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

extension PropertyListDecoder {
    func optionalDecode<T: Decodable>(_ type: T.Type, from object: Any?) -> T? {
        if let data = object as? Data {
            return try? PropertyListDecoder().decode(T.self, from: data)
        }
        return nil
    }
}

extension UserDefaults {
    var serverConfig: RSServerConfig? {
        get {
            return PropertyListDecoder().optionalDecode(RSServerConfig.self, from: object(forKey: Constants.RSServerConfigKey))
        }
        set {
            if let newValue = newValue {
                set(try? PropertyListEncoder().encode(newValue), forKey: Constants.RSServerConfigKey)
            } else {
                set(nil, forKey: Constants.RSServerConfigKey)
            }
        }
    }
    
    var lastUpdateTime: Int? {
        get { integer(forKey: Constants.RSServerLastUpdatedKey) }
        set { setValue(newValue, forKey: Constants.RSServerLastUpdatedKey) }
    }
    
    var traits: String? {
        get { string(forKey: Constants.RSTraitsKey) }
        set { setValue(newValue, forKey: Constants.RSTraitsKey) }
    }
    
    var buildVersionCode: String? {
        get { string(forKey: Constants.RSApplicationInfoKey) }
        set { setValue(newValue, forKey: Constants.RSApplicationInfoKey) }
    }
    
    var externalIds: String? {
        get { string(forKey: Constants.RSExternalIdKey) }
        set { setValue(newValue, forKey: Constants.RSExternalIdKey) }
    }
    
    var anonymousId: String? {
        get { string(forKey: Constants.RSAnonymousIdKey) }
        set { setValue(newValue, forKey: Constants.RSAnonymousIdKey) }
    }
}
