//
//  AHPopTransitionHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/25/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPopTransitionHandler: NSObject {
    weak var pinVC: AHPinContentVC?
    var isInPopTranstion = false
    let popTransitionVC = AHPopTransitionVC()
    let pan = UIPanGestureRecognizer(target: self, action: #selector(panHanlder(_:)))
    let popTransitionAnimator = AHPopTransitionAnimator()
    let popInteractiveTransition = AHPopInteractiveTransition()
}

extension AHPopTransitionHandler: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 && !isInPopTranstion{
            isInPopTranstion = true
            scrollView.addGestureRecognizer(pan)
//            pinVC?.present(popTransitionVC, animated: false, completion: nil)
            
            
            
//            AHPublicServices.shared.setTransition(delegate: self)
//            AHPublicServices.shared.navigatonController!.popViewController(animated: true)
        }
    }
    
    func panHanlder(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            print("began")
        case .changed:
            print("changed")
        case .cancelled, .ended:
            print("ended")
        default:
            break
        }
    }
}

extension AHPopTransitionHandler: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            print("popping")
            return popTransitionAnimator
        }
        
        
        if operation == .none {
            return nil
        }
        if operation == .push {
            print("## WARNING: AHPopTransitionAnimator should not be used when pushing a VC.")
            return nil
        }
        return nil
        
        
    }
}
