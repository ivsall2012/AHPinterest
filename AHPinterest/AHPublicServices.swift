//
//  AHPublicServices.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/23/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPublicServices: NSObject {
    static let shared = AHPublicServices()
    
    // Default push/pop transition animations
    let defaultTransitionDelegate = AHDefaultTransitionDelegate.shared
    
    // globel navVC
    weak var navigatonController: AHNavigationController?
}

// MARK:- Public Services
extension AHPublicServices {
    func setDefaultTransition() {
        setTransition(delegate: defaultTransitionDelegate)
    }
    
    func setTransition(delegate: UINavigationControllerDelegate) {
        navigatonController?.delegate = delegate
    }
}






