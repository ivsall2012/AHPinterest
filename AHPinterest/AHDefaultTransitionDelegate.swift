//
//  AHNavigationVCDelegate.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/23/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDefaultTransitionDelegate: NSObject {
    static let shared = AHDefaultTransitionDelegate()
    var transitionAnimator = AHTransitionAnimator()
    var operation: UINavigationControllerOperation {
        return transitionAnimator.state
    }
    
    fileprivate var showTransitionAnimation = true
    
    func turnOffTransitionAnimationTemporally() {
        showTransitionAnimation = false
    }
    
}
extension AHDefaultTransitionDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .none {
            return nil
        }
        
        if !showTransitionAnimation {
            showTransitionAnimation = true
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
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        transitionAnimator.state = .none
    }
}
