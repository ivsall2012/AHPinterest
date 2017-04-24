//
//  AHNavigationController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/19/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHNavigationController: UINavigationController {
    var navDelegate = AHNavigationVCDelegate.delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        AHPublicObjects.shared.navigatonController = self
        self.delegate = navDelegate
    }

    
}

