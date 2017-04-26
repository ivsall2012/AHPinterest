//
//  AHPopTransitionHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/25/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHPopInteractiveDelegate: NSObjectProtocol {
    // The scrollView's contentOffset. Only its y position will be used though.
    func popInteractiveForContentOffset() -> CGPoint
    
    // Interaction triggered when offset is less than the triggerYOffset. 
    // It should be "negative"!
    func popInteractiveForTriggerYOffset() -> CGFloat
    
    // The animating subject is the main to animate with. In the Pinterest case, it's the presenting imageView.
    func popInteractiveForAnimatingSubject() -> UIView
    
    // The animating subject will use this frame after the interactive animation. It should be relative to the background view. Because the animating subject will be "sticked" on the background view.
    func popInteractiveForAnimatingSubjectFinalFrame() -> CGRect
    
    // The attached view with animating subject. It will change its appearence as animation goes, as opposed to the animating subject which will not be changed.
    func popInteractiveForAnimatingSubjectBackground() -> UIView
    
    // The final view displayed after the interactive animation. And it will change its appearence too.
    func popInteractiveForAnimatingBackground() -> UIView
}


class AHPopInteractive: NSObject {
    weak var delegate: AHPopInteractiveDelegate!
    weak var vc: UIViewController!
    var isInPopTranstion = false
    let popTransitionVC = AHPopTransitionVC()
    var pan: UIPanGestureRecognizer?


    func attachView(vc: UIViewController,view: UIView){
        pan = UIPanGestureRecognizer(target: self, action: #selector(panHanlder(_:)))
        pan?.delegate = self
        view.addGestureRecognizer(pan!)
        self.vc = vc
    }
    
}

extension AHPopInteractive: UIGestureRecognizerDelegate, UICollectionViewDelegate {
    
    func panHanlder(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began,.changed:
            let pt = sender.location(in: popTransitionVC.view)
            let contentOffset = delegate.popInteractiveForContentOffset()
            let triggerYOffset = delegate.popInteractiveForTriggerYOffset()
            
            if  contentOffset.y < triggerYOffset && !isInPopTranstion {
                isInPopTranstion = true
                setupTransitionVC()
                
                popTransitionVC.modalPresentationStyle = .custom
                vc.present(popTransitionVC, animated: false, completion: nil)
                return
            }
            if contentOffset.y < triggerYOffset && isInPopTranstion {
                popTransitionVC.touchMoved(to: pt)
            }
        case .cancelled, .ended:
            isInPopTranstion = false
            popTransitionVC.dismiss(animated: false, completion: { 
                // check and see if popTransitionVC already triggered popping this pinVC
                
            })
        default:
            break
        }
    }
    
    func setupTransitionVC() {
        
        let subjectBg = delegate.popInteractiveForAnimatingSubjectBackground()
        popTransitionVC.subjectBg = subjectBg
        
        let subject = delegate.popInteractiveForAnimatingSubject()
        popTransitionVC.subject = subject
        
        let background = delegate.popInteractiveForAnimatingBackground()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
