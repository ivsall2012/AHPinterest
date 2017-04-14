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
    var pinVMs: [AHPinViewModel]?
}

extension AHLayoutHandler: AHLayoutDelegate {
    func AHLayoutSizeForFooterView() -> CGSize {
        return CGSize(width: 0.0, height: AHFooterHeight)
    }


    func AHLayoutSizeForHeaderView() -> CGSize {
        return CGSize(width: 0.0, height: AHHeaderHeight)
    }
    
    func AHLayoutHeightForUserAvatar(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat {
        return AHUserAvatarHeight
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
        return pinVM.heightForNote(font: AHNoteFont, width: width)
    }
    
}
