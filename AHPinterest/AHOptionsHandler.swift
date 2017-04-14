//
//  AHOptionsHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/13/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHOptionsHandler: NSObject {
    weak var pinVC: AHPinVC?
    weak var collectionView: UICollectionView? {
        didSet {
            if let collectionView = collectionView {
                collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:))))
            }
        }
    }
    
    
    fileprivate var optionsAnimator = AHOptionsAnimator()
    fileprivate var optionsVC = AHOptionsVC()
    
}



// MARK:- Events
extension AHOptionsHandler {
    @objc fileprivate func longPressHandler(_ sender: UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            let pt = sender.location(in: collectionView)
            if let indexPath = collectionView?.indexPathForItem(at: pt){
                guard let cell = collectionView?.cellForItem(at: indexPath) else{
                    return
                }
                longPressAnimation(cell: cell as! AHPinCell, startingPoint: pt)
                
            }
        case .changed:
            let point = sender.location(in: optionsVC.view)
            optionsVC.changed(point: point)
        case .ended, .cancelled, .failed, .possible:
            let point = sender.location(in: optionsVC.view)
            optionsVC.ended(point: point)
        }
    }
    fileprivate func longPressAnimation(cell: AHPinCell,startingPoint: CGPoint) {
        // either self.layer.masksToBounds = false or self.clipsToBounds = false will allow bgView goes out of bounds
        if !cell.isSelected {
            optionsVC.transitioningDelegate = optionsAnimator
            optionsAnimator.delegate = optionsVC
            optionsAnimator.preparePresenting(fromView: cell)
            optionsVC.startingPoint = collectionView?.convert(startingPoint, to: optionsVC.view)
            optionsVC.modalPresentationStyle = .custom
            pinVC?.present(optionsVC, animated: true, completion: nil)
        }
    }
}
