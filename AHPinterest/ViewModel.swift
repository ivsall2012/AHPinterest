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
        
        collectionView.contentInset = .init(top: 23, left: 5, bottom: 10, right: 5)
        collectionView.register(AHCollectionRefreshHeader.self, forSupplementaryViewOfKind: AHCollectionRefreshHeaderKind, withReuseIdentifier: "AHCollectionRefreshHeaderKind")
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = AHLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        layout.delegate = self
        
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
                guard let cell = collectionView.cellForItem(at: indexPath) else{
                    return
                }
                longPressAnimation(cell: cell as! PinCell, startingPoint: pt)
                
            }
        case .changed:
            let point = sender.location(in: modalVC.view)
            modalVC.changed(point: point)
        case .ended, .cancelled, .failed, .possible:
            let point = sender.location(in: modalVC.view)
            modalVC.ended(point: point)
        }
    }
    func longPressAnimation(cell: PinCell,startingPoint: CGPoint) {
        // either self.layer.masksToBounds = false or self.clipsToBounds = false will allow bgView goes out of bounds
        if !cell.isSelected {
            self.modalVC.transitioningDelegate = self.animator
            self.animator.delegate = self.modalVC
            self.animator.preparePresenting(fromView: cell)
            self.modalVC.startingPoint = collectionView.convert(startingPoint, to: self.modalVC.view)
            self.modalVC.modalPresentationStyle = .custom
            self.mainVC?.present(self.modalVC, animated: true, completion: nil)
        }
    }
}



extension ViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelected")
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension ViewModel: AHLayoutDelegate {
    func AHLayoutSizeForHeaderView() -> CGSize {
        return CGSize(width: 0.0, height: 300)
    }

    func AHLayoutForHeaderView() -> UIView {
        let view = UIView(frame: .init(x: 0, y: 0, width: 200, height: 400))
        return view
    }
    
    func AHLayoutForFooterView() -> UIView {
        let view = UIView(frame: .init(x: 0, y: 0, width: 200, height: 400))
        return view
    }
    
    func AHLayoutHeightForUserAvatar(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: AHCollectionRefreshHeaderKind, withReuseIdentifier: AHCollectionRefreshHeaderKind, for: indexPath)
        return header
    }
    
    
}







