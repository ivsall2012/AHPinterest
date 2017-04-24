//
//  AHNavigationVCDelegate.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/23/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHNavigationVCDelegate: NSObject {
    static let delegate = AHNavigationVCDelegate()
    var transitionAnimator = AHTransitionAnimator()
    var operation: UINavigationControllerOperation {
        return transitionAnimator.state
    }
}
extension AHNavigationVCDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .none {
            return nil
        }
        
        if operation == .push {
            let toVC = toVC as! AHTransitionPushToDelegate
            let fromVC = fromVC as! AHTransitionPushFromDelegate
            transitionAnimator.pushFromDelegate = fromVC
            transitionAnimator.pushToDelegate = toVC
        }else{
            let toVC = toVC as! AHTransitionPopToDelegate
            let fromVC = fromVC as! AHTransitionPopFromDelegate
            transitionAnimator.popToDelegate = toVC
            transitionAnimator.popFromDelegate = fromVC
            
        }
        
        
        transitionAnimator.state = operation
        return transitionAnimator
    }
}
