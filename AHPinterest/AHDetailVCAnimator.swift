//
//  AHDetailVCAnimator.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/20/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHDetailVCAnimatorDelegate: NSObjectProtocol {
    func detailVCAnimatorForSelectedCell() -> AHPinCell?
    func detailVCAnimatorForContentCell() -> AHPinContentCell?
}

class AHDetailVCAnimator: NSObject {
    weak var delegate: AHDetailVCAnimatorDelegate?
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
        guard let delegate = delegate,
            let toVC  = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
        else {
            return
        }
        toVC.view.layoutIfNeeded()
        
        guard let contentCell = delegate.detailVCAnimatorForContentCell(),
            let pinCell = delegate.detailVCAnimatorForSelectedCell()
        else {
            return
        }
        
        let mask = UIView(frame: toVC.view.bounds)
        mask.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        context.containerView.addSubview(mask)


        let smallImageFrame = pinCell.convert(pinCell.imageView.frame, to: fromVC.view)

        let view1 = UIView(frame: smallImageFrame)
        view1.backgroundColor = UIColor.red
        view1.alpha = 0.7
        


        let fullImageSize = contentCell.pinImageView.bounds.size
        let xRatio = pinCell.imageView.bounds.size.width / fullImageSize.width
        let yRatio = pinCell.imageView.bounds.size.height / fullImageSize.height

        let imgFrame = contentCell.pinImageView.frame
        let newImgOrigin = contentCell.convert(imgFrame, to: fromVC.view).origin
        let dy = newImgOrigin.y
        let dy_ = dy * yRatio

        
        let dx = newImgOrigin.x
        let dx_ = dx * xRatio

        let newY = (smallImageFrame.origin.y - dy_)
        let newX = (smallImageFrame.origin.x - dx_)

        
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        
//******* CHANGE layer.position FIRST to match anchorPoint  **************
        snapshot?.layer.position = .init(x: snapshot!.frame.origin.x + 0, y: snapshot!.frame.origin.y + 0)
        snapshot?.layer.anchorPoint = .init(x: 0, y: 0)
//******* CHANGE layer.position FIRST to match anchorPoint  **************
        
        
        let transformA = CGAffineTransform(translationX: newX, y: newY)
        let transformB = CGAffineTransform(scaleX: xRatio, y: yRatio)
        

        context.containerView.addSubview(snapshot!)

        snapshot!.transform = transformB.concatenating(transformA)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: { 
            snapshot!.transform = .identity
            }) { (_) in
                context.containerView.addSubview(toVC.view)
                snapshot?.removeFromSuperview()
                context.completeTransition(true)
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


//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if
//                let fromCell = delegate.detailVCAnimatorForSelectedCell(){
//
//                let mask = UIView(frame: toVC.view.bounds)
//                mask.backgroundColor = UIColor.white.withAlphaComponent(0.7)
//                context.containerView.addSubview(mask)
//
//
//                let newFrame = fromCell.convert(fromCell.imageView.frame, to: fromVC.view)
//                context.containerView.addSubview(toVC.view)
//
//                let view1 = UIView(frame: newFrame)
//                view1.backgroundColor = UIColor.red
//                context.containerView.addSubview(view1)


//                let fullImageSize = contentCell.pinImageView.bounds.size
//                let xRatio = fromCell.imageView.bounds.size.width / fullImageSize.width
//                let yRatio = fromCell.imageView.bounds.size.height / fullImageSize.height
//
//
//                let dy = contentCell.pinImageView.frame.origin.y
//                let dy_ = dy / yRatio
//                print("dy:\(dy) dy_:\(dy_) yRatio:\(yRatio)")
//                let dx = contentCell.pinImageView.frame.origin.x
//                let dx_ = dx / xRatio
//
//                let newY = newFrame.origin.y - dy_
//                let newX = newFrame.origin.x - dx_
//
//                let transformA = CGAffineTransform(translationX: newX, y: newY)
//                let transformB = CGAffineTransform(scaleX: xRatio, y: yRatio)
//                toVC.view.frame.origin = CGPoint(x: newX, y: newY)
//                print("newFrame:\(newFrame)")
//                print("newX:\(newX) newY:\(newY)")
//                UIView.animate(withDuration: 5, animations:{
//                    print("animating...")
//                    //                toVC.view.transform = .identity
//                    toVC.view.frame.origin = CGPoint.zero
//                }) { (_) in
//                    print("finished animating")
//                    context.completeTransition(true)
//                    mask.removeFromSuperview()
//
//                }
//
//            }
//        }
