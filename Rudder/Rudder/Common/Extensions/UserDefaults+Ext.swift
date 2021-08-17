//
//  UserDefaults+Ext.swift
//  Rudder
//
//  Created by Pallab Maiti on 13/08/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {    
    var serverConfig: String? {
        get { string(forKey: Constants.RSServerConfigKey) }
        set { setValue(newValue, forKey: Constants.RSServerConfigKey) }
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
