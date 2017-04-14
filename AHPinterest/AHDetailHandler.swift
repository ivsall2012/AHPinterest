//
//  AHDetailHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/13/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDetailHandler: NSObject {
    weak var pinVC: AHPinVC?
    var pinVMs: [AHPinViewModel]?
}

extension AHDetailHandler {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let detailVC = storyboard.instantiateViewController(withIdentifier: "AHDetailVC") as? AHDetailVC
//        
//        if let detailVC = detailVC {
//            //            animator.delegate = self
//            //            animator.actingIndexPath = indexPath
//            //            photoBrowserVC.transitioningDelegate = animator
//            detailVC.modalPresentationStyle = .custom
//            detailVC.pinVMs = pinVMs
//            detailVC.currentIndexPath = indexPath
//            pinVC?.present(detailVC, animated: true, completion: nil)
//            
//        }
    }
}
