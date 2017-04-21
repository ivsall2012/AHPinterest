//
//  AHDetailVCAnimator.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/20/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

fileprivate enum AHDetailVCAnimatorState {
    case none
    case presenting
    case dismissing
}

class AHDetailVCAnimator: NSObject {
    fileprivate var state: AHDetailVCAnimatorState = .none
}

extension AHDetailVCAnimator : UIViewControllerTransitioningDelegate{
    // callecd when presenting
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .presenting
        return self
    }
    // called when dismissing
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .dismissing
        return self
    }
}

extension AHDetailVCAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch state {
        case .presenting:
            animationTransitionForPresenting(using: transitionContext)
        case .dismissing:
            animationTransitionForDismissing(using: transitionContext)
        default:
            break
        }
        animationTransitionForPresenting(using: transitionContext)
    }
    // for presenting aniamtion, will be called just before viewWillAppear:
    func animationTransitionForPresenting(using context: UIViewControllerContextTransitioning){
        if let toVC  = context.viewController(forKey: UITransitionContextViewControllerKey.to) {
            let view = UIView(frame: UIScreen.main.bounds)
            view.backgroundColor = UIColor.white
            context.containerView.addSubview(toVC.view)
            context.containerView.addSubview(view)
            UIView.animate(withDuration: 0.25, animations: {
                view.alpha = 1.0
                view.backgroundColor = UIColor.red
            }) { (_) in
                
                context.completeTransition(true)
                view.removeFromSuperview()
            }
        }

        
        
    }
    
    /// For dismissing animation
    func animationTransitionForDismissing(using context: UIViewControllerContextTransitioning){
        
        
        
    }
    
}
