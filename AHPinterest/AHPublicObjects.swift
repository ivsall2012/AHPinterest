//
//  AHPublicObjects.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/23/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPublicObjects: NSObject {
    static let shared = AHPublicObjects()
    fileprivate var _currentItem: Int = -1
    
    // make it thread safe, for fun?
    var currentItem:Int {
        get {
            return self._currentItem
        }
        
        set {
            if !Thread.isMainThread {
                
                DispatchQueue.main.async {
                    self._currentItem = newValue
                }
                
            }else{
                self._currentItem = newValue
            }
        }
    }
    // globel navVC
    weak var navigatonController: AHNavigationController?
}
