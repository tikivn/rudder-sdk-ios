//
//  UIViewController+Ext.swift
//  Rudder
//
//  Created by Pallab Maiti on 21/10/21.
//  Copyright © 2021 Rudder Labs India Pvt Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    static func rudderSwizzleView() {
        let thisClass: AnyClass? = self.superclass()
        let originalSelector = #selector(viewDidAppear(_:))
        let swizzledSelector = #selector(rsViewDidAppear(_:))
        
        if let originalMethod = class_getInstanceMethod(thisClass, originalSelector), let swizzledMethod = class_getInstanceMethod(thisClass, swizzledSelector) {
            let didAddMethod = class_addMethod(thisClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(thisClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    @objc
    func rsViewDidAppear(_ animated: Bool) {
        var name: String = self.description
        name = name.replacingOccurrences(of: "ViewController", with: "")
        RSClient.shared.screen(name, properties: ["automatic": true, "name": name])
        rsViewDidAppear(animated)
    }
}
