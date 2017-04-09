//
//  ViewModel.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit
import AVFoundation


class ViewModel: NSObject {
    var collectionView: UICollectionView
    var layout: AHLayout?
    var pinVMs: [PinViewModel]?
    var reusablePinCellID: String
    let animator: AHShareAnimator = AHShareAnimator()
    var modalVC: AHShareModalVC = AHShareModalVC()
    weak var mainVC: UIViewController?
    
    init(collectionView: UICollectionView, reusablePinCellID: String) {
        self.collectionView = collectionView
        self.reusablePinCellID = reusablePinCellID
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        layout = (collectionView.collectionViewLayout as! AHLayout)
        layout?.delegate = self
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:))))
    }
    
    func loadNewData(completion: @escaping (_ success: Bool)->Swift.Void) {
        AHNetowrkTool.tool.loadNewData { (pinVMs) in
            self.pinVMs = pinVMs
            self.collectionView.reloadData()
            completion(true)
        }
    }
    
    
    
}


// MARK:- Events
extension ViewModel {
    @objc fileprivate func longPressHandler(_ sender: UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            let pt = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: pt){
                guard let item = collectionView.cellForItem(at: indexPath) else{
                    return
                }
                longPressAnimation(item: item as! PinCell, startingPoint: pt)
                
            }
        case .changed:
            let point = sender.location(in: modalVC.view)
            modalVC.changed(point: point)
        case .ended, .cancelled, .failed, .possible:
            let point = sender.location(in: modalVC.view)
            modalVC.ended(point: point)
        }
    }
    func longPressAnimation(item: PinCell,startingPoint: CGPoint) {
        // either self.layer.masksToBounds = false or self.clipsToBounds = false will allow bgView goes out of bounds
        if !item.isSelected {
            self.modalVC.transitioningDelegate = self.animator
            self.animator.fromView = item
            self.modalVC.startingPoint = collectionView.convert(startingPoint, to: self.modalVC.view)
            self.modalVC.modalPresentationStyle = .custom
            self.mainVC?.present(self.modalVC, animated: true, completion: nil)
        }
    }
}


extension ViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelected")
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension ViewModel: AHLayoutDelegate {
    internal func AHLayoutHeightForUserAvatar(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
        return userAvatarHeight
    }

    func AHLayoutHeightForPhotoAt(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
        guard let pinVM = pinVMs?[indexPath.item] else {
            return 0.0
        }
        
        let pin = pinVM.pinModel
        let boundRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(DBL_MAX))
        let rect = AVMakeRect(aspectRatio: pin.imageSize , insideRect: boundRect)
        return rect.height
    }
    
    func AHLayoutHeightForNote(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
        guard let pinVM = pinVMs?[indexPath.item] else {
            return 0.0
        }
        return pinVM.heightForNote(font: noteFont, width: width)
    }
    
}

extension ViewModel : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let pinVMs = pinVMs else {
            return 0
        }
        return pinVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let PinCell = collectionView.dequeueReusableCell(withReuseIdentifier: reusablePinCellID, for: indexPath) as! PinCell
        
        guard let pinVM = pinVMs?[indexPath.item] else {
            fatalError("pinVM is nil!!")
        }
    
        PinCell.mainVC = mainVC
        PinCell.pinVM = pinVM
        return PinCell
    }
    
    
    
    
}







