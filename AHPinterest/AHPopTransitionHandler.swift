//
//  AHPopTransitionHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/25/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPopTransitionHandler: NSObject {
    weak var pinVC: AHPinContentVC!
    var isInPopTranstion = false
    let popTransitionVC = AHPopTransitionVC()
    var pan: UIPanGestureRecognizer?
    let popTransitionAnimator = AHPopTransitionAnimator()
    let popInteractiveTransition = AHPopInteractiveTransition()
    var contentOffset = CGPoint.zero
    weak var targetView: UIView?
    func attachView(view: UIView){
        pan = UIPanGestureRecognizer(target: self, action: #selector(panHanlder(_:)))
        pan?.delegate = self
        view.addGestureRecognizer(pan!)
        targetView = view
        
    }
    
}

extension AHPopTransitionHandler: UIGestureRecognizerDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            contentOffset = scrollView.contentOffset
        }else{
            contentOffset = CGPoint.zero
        }
    }
    
    func panHanlder(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began,.changed:
            let pt = sender.location(in: popTransitionVC.view)
            if contentOffset.y < -44.0 && !isInPopTranstion {
                isInPopTranstion = true
                setupTransitionVC()
                
                popTransitionVC.modalPresentationStyle = .custom
                pinVC.present(popTransitionVC, animated: false, completion: nil)
                return
            }
            if contentOffset.y < -44.0 && isInPopTranstion {
                popTransitionVC.touchMoved(to: pt)
            }
        case .cancelled, .ended:
            isInPopTranstion = false
            popTransitionVC.dismiss(animated: false, completion: nil)
        default:
            break
        }
    }
    
    func setupTransitionVC() {
        guard let presentingCell = pinVC.presentingCell,
            let bgSnap = pinVC.view.snapshotView(afterScreenUpdates: true),
        let presentingView = presentingCell.pinImageView.snapshotView(afterScreenUpdates: true)
            else{
            print("presentingCell or bgSnap is nil....")
            return
        }
        
        let whiteAreaFrames = presentingCell.convert(presentingCell.pinImageView.frame, to: pinVC.view)
        
        let whiteArea = UIView(frame: whiteAreaFrames)
        presentingView.frame = whiteAreaFrames
        whiteArea.backgroundColor = UIColor.white
        bgSnap.addSubview(whiteArea)
        popTransitionVC.bgSnap = bgSnap
        popTransitionVC.presentingView = presentingView
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
