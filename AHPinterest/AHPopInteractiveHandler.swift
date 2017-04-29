//
//  AHPopInteractiveHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPopInteractiveHandler: NSObject {
    weak var pinContentVC: AHPinContentVC! {
        didSet {
            popInteractive.attachView(vc: pinContentVC, view: pinContentVC.view)
        }
    }
    var popInteractive = AHPopInteractive()
    
    
    var presentingCell: AHPinContentCell {
        return pinContentVC.presentingCell!
    }
    
    var selectedCell: AHPinCell {
        return pinContentVC.selectedCell!
    }
    
    var whiteAreaFrame: CGRect {
        return presentingCell.convert(presentingCell.pinImageView.frame, to: pinContentVC.view)
    }
    
    var contentOffSet = CGPoint.zero
    
    override init() {
        super.init()
        popInteractive.delegate = self
    }
}



extension AHPopInteractiveHandler: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffSet = scrollView.contentOffset
    }
}

extension AHPopInteractiveHandler: AHPopInteractiveDelegate {
    func popInteractiveForContentOffset() -> CGPoint {
        return contentOffSet
    }
    func popInteractiveForTriggerYOffset() -> CGFloat {
        guard let inset = pinContentVC?.collectionView?.contentInset else {
            return -9999.0
        }
        return -inset.top
    }
    func popInteractiveForAnimatingSubject() -> UIView{
        let presentingView = presentingCell.pinImageView.snapshotView(afterScreenUpdates: true)
        presentingView!.frame = whiteAreaFrame
        return presentingView!
    }
    
    func popInteractiveForAnimatingSubjectFinalFrame() -> CGRect {
        guard let childViewControllers = pinContentVC.navigationController?.childViewControllers else {
            fatalError("NO childViewControllers?")
        }
        // the last vc the current one, count -1
        // the second last vc is count - 2
        let previousIndex = childViewControllers.count - 2
        
        guard let vc = childViewControllers[previousIndex] as? AHTransitionProperties
            else {
            fatalError("No previous VC comfirming AHTransitionProperties")
        }

        guard let selectedCell = vc.selectedCell else {

            fatalError("No selectedCell")
        }
        
        let previousVC = vc as! UIViewController
        
        let frame = selectedCell.convert(selectedCell.imageView.frame, to: previousVC.view)
        
        return frame
        
    }
    
    func popInteractiveForAnimatingSubjectBackground() -> UIView {
        let bgSnap = pinContentVC.view.snapshotView(afterScreenUpdates: true)
        // give the frame extra 2 points on all sides to cover up fully
        let newFrame = whiteAreaFrame.insetBy(dx: -2, dy: -2)
        let whiteArea = UIView(frame: newFrame)
        whiteArea.backgroundColor = UIColor.white
        bgSnap!.addSubview(whiteArea)
        return bgSnap!
    }
    
    func popInteractiveForAnimatingBackground() -> UIView {
        guard let childViewControllers = pinContentVC.navigationController?.childViewControllers else {
            fatalError("NO childViewControllers?")
        }
        // the last vc the current one, count -1
        // the second last vc is count - 2
        let previousIndex = childViewControllers.count - 2
        
        let finalFrame = self.popInteractiveForAnimatingSubjectFinalFrame()
        let vc = childViewControllers[previousIndex]
        
        let snapshot = vc.view.snapshotView(afterScreenUpdates: true)
        vc.view.layoutIfNeeded()
        
        let newFrame = finalFrame.insetBy(dx: -2, dy: -2)
        let whiteArea = UIView(frame: newFrame)
        whiteArea.backgroundColor = UIColor.white
        snapshot?.addSubview(whiteArea)
        return snapshot!
        
    }
    
}
