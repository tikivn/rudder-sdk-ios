//
//  String+Ext.swift
//  Rudder
//
//  Created by Pallab Maiti on 10/09/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import Foundation

extension String {
    func getUTF8Length() -> Int {
        return self.data(using: .utf8)?.count ?? 0
    }
}
