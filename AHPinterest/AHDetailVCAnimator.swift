//
//  AHDetailVCAnimator.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/20/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit



class AHDetailVCAnimator: NSObject {
    var state: UINavigationControllerOperation = .none
}

extension AHDetailVCAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch state {
        case .push:
            animationTransitionForPushing(using: transitionContext)
        case .pop:
            animationTransitionForPopping(using: transitionContext)
        default:
            break
        }
    }
    // for presenting aniamtion, will be called just before viewWillAppear:
    func animationTransitionForPushing(using context: UIViewControllerContextTransitioning){
        if let toVC  = context.viewController(forKey: UITransitionContextViewControllerKey.to) {
            
            let mask = UIView(frame: toVC.view.bounds)
            mask.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            context.containerView.addSubview(mask)
            
            context.containerView.addSubview(toVC.view)
            toVC.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

            
            // using asyncAfter is because by letting this method(animationTransitionForPushing) finish first, the toVC will then call viewDidLayoutSubviews which is the point the detailVC's collectionView.scrollToItem() finished scrolling and ready to display. After the viewDidLayoutSubviews, the following code then can access the correct view layouts.
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                
//                
//            })
            UIView.animate(withDuration: 5, animations:{
                toVC.view.transform = .identity
            }) { (_) in
                context.completeTransition(true)
                mask.removeFromSuperview()
                
            }
            
        }

        
        
    }
    
    /// For dismissing animation
    func animationTransitionForPopping(using context: UIViewControllerContextTransitioning){
        let fromVC  = context.viewController(forKey: UITransitionContextViewControllerKey.from)
        fromVC!.view.removeFromSuperview()
        fromVC?.removeFromParentViewController()
        context.completeTransition(true)
        
    }
    
}
