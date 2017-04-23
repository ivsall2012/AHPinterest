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
        
        guard let fromSnap = fromVC.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        
        let mask = UIView()
        mask.frame = toVC.view.bounds
        mask.backgroundColor = UIColor.white
        context.containerView.addSubview(mask)
        
        context.containerView.addSubview(fromSnap)
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
        toVC.view.isHidden = true
        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            imageView?.frame = newImgFrame
            fromSnap.transform = CGAffineTransform(scaleX: xRatio, y: yRatio)
            fromSnap.frame.origin = CGPoint(x: originOffsetX + AHCellPadding, y:  originOffsetY + newImgFrame.origin.y)
            }) { (_) in
                toVC.view.isHidden = false
                fromSnap.removeFromSuperview()
                context.completeTransition(true)

        }
        
        

        
    }
    
    
    
    
    /// For dismissing animation
    func animationTransitionForPopping(using context: UIViewControllerContextTransitioning){
        
    }
}

