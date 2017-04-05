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
    var photos: [Photo]
    var reusableCellID: String
        let animator: AHShareAnimator = AHShareAnimator()
        var modalVC: AHShareModalVC = AHShareModalVC()
    weak var mainVC: UIViewController?
    init(collectionView: UICollectionView, reusableCellID: String) {
        self.collectionView = collectionView
        self.reusableCellID = reusableCellID
        self.photos = Photo.allPhotos()
    }
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        layout = (collectionView.collectionViewLayout as! AHLayout)
        layout?.delegate = self
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:))))
    }
    func longPressHandler(_ sender: UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            let pt = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: pt){
                guard let item = collectionView.cellForItem(at: indexPath) else{
                    return
                }
                longPressAnimation(item: item as! Cell, startingPoint: pt)
                
            }
        case .changed:
            let point = sender.location(in: modalVC.view)
            modalVC.changed(point: point)
        case .ended, .cancelled, .failed, .possible:
            let point = sender.location(in: modalVC.view)
            modalVC.ended(point: point)
        }
    }
    func longPressAnimation(item: Cell,startingPoint: CGPoint) {
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
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let photo = photos[indexPath.item]
        let boundRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(DBL_MAX))
        let rect = AVMakeRect(aspectRatio: photo.image!.size, insideRect: boundRect)
        return rect.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(21)
        let photo = photos[indexPath.item]
        let font = UIFont.systemFont(ofSize: 15)
        let commentHeight = photo.heightForComment(font: font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
    
}

extension ViewModel : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellID, for: indexPath) as! Cell
        cell.mainVC = mainVC
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    
    
    
}







