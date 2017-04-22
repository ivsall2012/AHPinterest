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
        
        print("toVC.view.layoutIfNeeded()")
        
        
        print("about to animate")
        
//        let snap = fromVC.view.snapshotView(afterScreenUpdates: true)
//        context.containerView.addSubview(snap!)
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
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            toVC.view.transform = .identity
            imageView!.frame = contentCell.convert(contentCell.pinImageView.frame, to: toVC.view)
            }) { (_) in
                imageView!.removeFromSuperview()
                print("finished animating")
                context.completeTransition(true)
                print("traisiton ended")
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
