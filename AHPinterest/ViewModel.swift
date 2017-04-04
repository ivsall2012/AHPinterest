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
    }
}

extension ViewModel: UICollectionViewDelegateFlowLayout {

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
        
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    
    
    
}







