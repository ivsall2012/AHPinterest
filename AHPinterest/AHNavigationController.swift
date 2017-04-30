//
//  AHNavigationController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/19/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHNavigationController: UINavigationController {
    let transitionDelegate = AHTransitionDelegate()
    
    var operation: UINavigationControllerOperation {
        return transitionDelegate.operation
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.delegate = transitionDelegate
    }

    func turnOffTransitionOnce() {
        transitionDelegate.turnOffTransitionAnimationTemporally()
    }
    
}

