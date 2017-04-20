//
//  AHLayoutHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/10/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit
import AVFoundation

class AHLayoutHandler: NSObject {
    weak var pinVC: AHPinVC?
}



extension AHLayoutHandler: AHPinLayoutDelegate {
    func AHPinLayoutHeightForUserAvatar(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
        return AHUserAvatarHeight
    }
    
    func AHPinLayoutHeightForPhotoAt(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
        guard let pinVM = pinVC?.pinDataSource.pinVMs[indexPath.item] else {
            return 0.0
        }
        
        let pin = pinVM.pinModel
        let boundRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(DBL_MAX))
        let rect = AVMakeRect(aspectRatio: pin.imageSize , insideRect: boundRect)
        return rect.height
    }
    
    func AHPinLayoutHeightForNote(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
        guard let pinVM = pinVC?.pinDataSource.pinVMs[indexPath.item] else {
            return 0.0
        }
        return pinVM.heightForNote(font: AHNoteFont, width: width)
    }
    
    func AHPinLayoutSizeForHeader(collectionView: UICollectionView) -> CGSize? {
        guard let pinVC = pinVC else {
            return nil
        }
        if pinVC.showLayoutHeader {
            return CGSize(width: 0.0, height: AHPinLayoutHeaderHeight)
        }else{
            return nil
        }
        
    }
    
}
