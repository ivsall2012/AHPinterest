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
        
        
        
        
        context.containerView.addSubview(fromVC.view)
        context.containerView.addSubview(toVC.view)

        toVC.view.layoutIfNeeded()
        
        guard let contentCell = delegate.detailVCAnimatorForContentCell(),
            let pinCell = delegate.detailVCAnimatorForSelectedCell()
            else {
                return
        }

        let imageView = pinCell.imageView.snapshotView(afterScreenUpdates: true)
        let smallImageFrame = pinCell.convert(pinCell.imageView.frame, to: fromVC.view)
        imageView!.frame = smallImageFrame
        context.containerView.addSubview(imageView!)
        

        let fullImageSize = contentCell.pinImageView.bounds.size
        let xRatio = fullImageSize.width / pinCell.imageView.bounds.size.width
        let yRatio = fullImageSize.height / pinCell.imageView.bounds.size.height
        
        let imgFrame = contentCell.pinImageView.frame
        let newImgFrame = contentCell.convert(imgFrame, to: fromVC.view)

        
        let originOffsetX = -(smallImageFrame.origin.x) * xRatio
        let originOffsetY = -(smallImageFrame.origin.y) * yRatio
        
        
        let fromFrame = fromVC.view.frame
        
        processToView(context: context)
        
        
        UIView.animateKeyframes(withDuration: 0.50, delay: 0.0, options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.50, animations: {
                toVC.view.transform = .identity
                imageView?.frame = newImgFrame
                fromVC.view.transform = CGAffineTransform(scaleX: xRatio, y: yRatio)
                fromVC.view.frame.origin = CGPoint(x: originOffsetX + AHCellPadding, y:  originOffsetY + newImgFrame.origin.y)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3, animations: {
                toVC.view.alpha = 1.0
            })
            
            
            
            }) { (_) in
                context.containerView.addSubview(toVC.view)
                imageView?.removeFromSuperview()
                fromVC.view.removeFromSuperview()
                fromVC.view.frame = fromFrame
                fromVC.view.transform = .identity
                context.completeTransition(true)
        }
        
        
//        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
//            
//            }) { (_) in
//                
//
//        }
        
        

        
    }
    
    
    
    func processToView(context: UIViewControllerContextTransitioning) {
        guard let delegate = delegate,
            let toVC  = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
            else {
                return
        }
        
        
        guard let contentCell = delegate.detailVCAnimatorForContentCell(),
            let pinCell = delegate.detailVCAnimatorForSelectedCell()
            else {
                return
        }
        
        let mask = UIView()
        mask.frame = toVC.view.bounds
        mask.backgroundColor = UIColor.white
        context.containerView.insertSubview(mask, belowSubview: fromVC.view)
        
        
        let imageView = pinCell.imageView.snapshotView(afterScreenUpdates: true)
        let smallImageFrame = pinCell.convert(pinCell.imageView.frame, to: fromVC.view)
        imageView!.frame = smallImageFrame
        
        
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
        
        
        let anchorPoint = CGPoint(x: 0, y: 0)
        //******* CHANGE layer.position FIRST to match anchorPoint  **************
        toVC.view.layer.position = .init(x: toVC.view.frame.origin.x + anchorPoint.x, y: toVC.view.frame.origin.y + anchorPoint.y)
        toVC.view.layer.anchorPoint = .init(x: 0, y: 0)
        //******* CHANGE layer.position FIRST to match anchorPoint  **************
        
        
        let transformA = CGAffineTransform(translationX: newX, y: newY)
        let transformB = CGAffineTransform(scaleX: xRatio, y: yRatio)
        
        
        toVC.view.transform = transformB.concatenating(transformA)
        toVC.view.alpha = 0.0
        
    }
    
    
    /// For dismissing animation
    func animationTransitionForPopping(using context: UIViewControllerContextTransitioning){
        

    }
}

