//
//  AHAnimator.swift
//  AHWeiBo
//
//  Created by Andy Hurricane on 3/2/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

enum AHShareAnimatorState {
    case none
    case presenting
    case dismissing
}

protocol AHAnimatorDelegate: NSObjectProtocol {
    
}

class AHShareAnimator: NSObject {
    weak var delegate: AHAnimatorDelegate?
    weak var fromView: UIView?
    var state: AHShareAnimatorState = .none
}


extension AHShareAnimator : UIViewControllerTransitioningDelegate{
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        
//        let presentationVC =  AHPresentationVC(presentedViewController: presented, presenting: presenting)
//        presentationVC.presentedViewFrame = presentedViewFrame
//        return presentationVC
//    }
    
    // wil animate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .presenting
        return self
    }
    // did animate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .dismissing
        return self
    }
}

extension AHShareAnimator : UIViewControllerAnimatedTransitioning {
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
    }
    // for presenting aniamtion, will be called just before viewWillAppear:
    func animationTransitionForPresenting(using context: UIViewControllerContextTransitioning){
        let fromViewByKey = context.view(forKey: UITransitionContextViewKey.from)
        
        guard let fromView = fromViewByKey == nil ? self.fromView: fromViewByKey else { return }
        guard let toView = context.view(forKey: UITransitionContextViewKey.to) else { return}
        
        guard let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? AHShareModalVC else { return }
        
        let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: true)
        fromViewSnapshot?.frame = fromView.convert(fromViewSnapshot!.frame, to: toView)
        fromViewSnapshot?.alpha = 0.6
        context.containerView.addSubview(toView)
        toView.insertSubview(fromViewSnapshot!, at: 0)
        
        toView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        UIView.animate(withDuration: 0.2, animations: {
            toView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            }, completion: { (_) in
                // the following will tell the VC to display views and call viewDidAppear:
                context.completeTransition(true)
                
                // this button animation has to be called after VC's viewDidAppear:
                toVC.buttonAnimation()
        })

    }
        
}


/// For dismissing animation
    func animationTransitionForDismissing(using context: UIViewControllerContextTransitioning){
        
        // get presentedView by UITransitionContextViewKey.from
        if let fromView = context.view(forKey: UITransitionContextViewKey.from) {
            fromView.removeFromSuperview()
            fromView.subviews.map({$0.removeFromSuperview()})
            context.completeTransition(true)
        }
        
        
    }






class AHPresentationVC: UIPresentationController {
    fileprivate lazy var maskView = UIView()
    var presentedViewFrame = CGRect.zero
    override func containerViewWillLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        // adjust presentedView position
        presentedView?.frame = presentedViewFrame
        
        // setup mask
//        setupBackgroundMask()
    }
}


// MARK:- setup UI
//extension AHPresentationVC {
//    fileprivate func setupBackgroundMask() {
//        containerView?.insertSubview(maskView, at: 0)
//        
//        maskView.frame = (containerView?.bounds)!
//        maskView.backgroundColor = UIColor.clear
//        maskView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(maskTapped(_:)))
//        maskView.addGestureRecognizer(tapGesture)
//    }
//}
//
//// MARK:- Events
//extension AHPresentationVC {
//    @objc fileprivate func maskTapped(_ sender: UIGestureRecognizer){
//        presentedViewController.dismiss(animated: true, completion: nil)
//    }
//}




