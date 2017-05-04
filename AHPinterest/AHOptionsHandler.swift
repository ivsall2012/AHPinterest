//
//  AHOptionsHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/13/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHOptionsHandlerDelegate: NSObjectProtocol {
    func optionsHandlerShouldAnimate(on cell: UIView) -> Bool
    func optionsHandlerForFromCell(at point: CGPoint) -> UIView?
}


class AHOptionsHandler: NSObject {
    // The delegate provides fromCell
    weak var delegate: AHOptionsHandlerDelegate?
    
    // The controller that does the presentation job
    weak var presenterVC: UIViewController!
    
    // The view that is needed to add this option animation. (FYI, unowned objects don't have didSet listener)
    weak var targetView: UIView!
    
    fileprivate var optionsAnimator = AHOptionsAnimator()
    fileprivate var optionsVC = AHOptionsVC()
    
    init(presenterVC: UIViewController, targetView: UIView, delegate: AHOptionsHandlerDelegate) {
        self.presenterVC = presenterVC
        self.targetView = targetView
        self.delegate = delegate
        super.init()
        targetView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:))))
    }
    
}



// MARK:- Events
extension AHOptionsHandler {
    @objc fileprivate func longPressHandler(_ sender: UILongPressGestureRecognizer){
        guard let delegate = delegate else {
            return
        }
        
        switch sender.state {
        case .began:
            let pt = sender.location(in: targetView)
            if let cell = delegate.optionsHandlerForFromCell(at: pt) {
                longPressAnimation(cell: cell, startingPoint: pt)
            }
            
        
        case .changed:
            let point = sender.location(in: optionsVC.view)
            optionsVC.changed(point: point)
        
        case .ended, .cancelled, .failed, .possible:
            let point = sender.location(in: optionsVC.view)
            optionsVC.ended(point: point)
        }
    }
    fileprivate func longPressAnimation(cell: UIView,startingPoint: CGPoint) {
        guard let delegate = delegate else {
            return
        }
        // either self.layer.masksToBounds = false or self.clipsToBounds = false will allow bgView goes out of bounds
        if delegate.optionsHandlerShouldAnimate(on: cell) {
            optionsAnimator.start(fromCell: cell)
            optionsVC.transitioningDelegate = optionsAnimator
            optionsAnimator.delegate = optionsVC
            optionsVC.startingPoint = targetView.convert(startingPoint, to: optionsVC.view)
            optionsVC.modalPresentationStyle = .custom
            presenterVC.present(optionsVC, animated: true, completion: nil)
        }
    }
}
