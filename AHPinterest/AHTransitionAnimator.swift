//
//  AHDetailVCAnimator.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/20/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit



// SelectedCell is the one in AHPinVC
// PresentingCell is the one in AHDetailVC

// SelectedCell --> PresentingCell
protocol AHTransitionPushFromDelegate: NSObjectProtocol {
    func transitionPushFromSelectedCell() -> AHPinCell?
}

protocol AHTransitionPushToDelegate: NSObjectProtocol {
    func transitionPushToPresentingCell() -> AHPinContentCell?
}

// PresentingCell --> SelectedCell
protocol AHTransitionPopToDelegate: NSObjectProtocol {
    func transitionPopToSelectedCell() -> AHPinCell?
}

protocol AHTransitionPopFromDelegate: NSObjectProtocol {
    func transitionPopFromPresentingCell() -> AHPinContentCell?
}




class AHTransitionAnimator: NSObject {
    weak var pushFromDelegate: AHTransitionPushFromDelegate?
    weak var pushToDelegate: AHTransitionPushToDelegate?
    weak var popFromDelegate: AHTransitionPopFromDelegate?
    weak var popToDelegate: AHTransitionPopToDelegate?
    
    
    var state: UINavigationControllerOperation = .none
}

extension AHTransitionAnimator : UIViewControllerAnimatedTransitioning {
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
        guard let pushFromDelegate = pushFromDelegate,
            let pushToDelegate = pushToDelegate,
            let toVC  = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
        else {
            return
        }
        
        
        
//        context.containerView automatically added fromVC.view when pushing
        
        let mask = UIView()
        mask.frame = CGRect(x: -999, y: -999, width: 9999, height: 9999)
        mask.backgroundColor = UIColor.white
        context.containerView.insertSubview(mask, belowSubview: fromVC.view)
        
        context.containerView.addSubview(toVC.view)

        toVC.view.layoutIfNeeded()
        
        guard let pinCell = pushFromDelegate.transitionPushFromSelectedCell() else
        {
            print("pushFromCell nil")
            return
        }
        
        
        guard let contentCell = pushToDelegate.transitionPushToPresentingCell()
            else {
                print("pushToCell is nil")
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
                mask.removeFromSuperview()
                imageView?.removeFromSuperview()
                fromVC.view.transform = .identity
                fromVC.view.frame = fromFrame
                context.completeTransition(true)
        }
        
    }
    
    
    
    func processToView(context: UIViewControllerContextTransitioning) {
        guard let pushFromDelegate = pushFromDelegate,
            let pushToDelegate = pushToDelegate,
            let toVC  = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
            else {
                return
        }
        
        
        guard let pinCell = pushFromDelegate.transitionPushFromSelectedCell(),
            let contentCell = pushToDelegate.transitionPushToPresentingCell()
            else {
                return
        }
        
        
        let smallImageFrame = pinCell.convert(pinCell.imageView.frame, to: fromVC.view)

        
        
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
        
        guard let popFromDelegate = popFromDelegate,
            let popToDelegate = popToDelegate,
            let pinVC  = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let detailVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
            else {
                return
        }

        

        context.containerView.addSubview(pinVC.view)
        pinVC.view.layoutIfNeeded()
        
        guard let pinCell = popToDelegate.transitionPopToSelectedCell() else
        {
            print("popToSelectedCell nil")
            return
        }
        
        
        guard let contentCell = popFromDelegate.transitionPopFromPresentingCell()
            else {
                print("popFromPresentingCell is nil")
                return
        }
        
        let imageView = contentCell.pinImageView.snapshotView(afterScreenUpdates: true)
        let fullFrame = contentCell.convert(contentCell.pinImageView.frame, to: pinVC.view)
        imageView!.frame = fullFrame
        context.containerView.addSubview(imageView!)
        
        
        let fullImageSize = contentCell.pinImageView.bounds.size
        let xRatio = (fullImageSize.width / pinCell.imageView.bounds.size.width)
        let yRatio = (fullImageSize.height / pinCell.imageView.bounds.size.height)
        
        
        
        let imgFrame = pinCell.imageView.frame
        let smallFrame = pinCell.convert(imgFrame, to: detailVC.view)
        
        let originOffsetX = -(smallFrame.origin.x) * xRatio
        let originOffsetY = -(smallFrame.origin.y) * yRatio
        
        let pinVCFrame = pinVC.view.frame
        pinVC.view.transform = CGAffineTransform(scaleX: xRatio, y: yRatio)
        pinVC.view.frame.origin = CGPoint(x: originOffsetX + AHCellPadding, y:  originOffsetY + fullFrame.origin.y)

        let mask = UIView()
        mask.frame = CGRect(x: -999, y: -999, width: 9999, height: 9999)
        mask.backgroundColor = UIColor.white
        context.containerView.insertSubview(mask, belowSubview: detailVC.view)

        UIView.animate(withDuration: 0.5, animations: {
            detailVC.view.alpha = 0.0
            pinVC.view.transform = .identity
            pinVC.view.frame = pinVCFrame
            imageView?.frame = smallFrame
            }) { (_) in
                mask.removeFromSuperview()
                detailVC.view.removeFromSuperview()
                imageView?.removeFromSuperview()
                context.completeTransition(true)
        }
        

    }
}

