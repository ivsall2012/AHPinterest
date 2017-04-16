//
//  ViewModel.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit


class AHPinDelegate: NSObject {
    weak var refreshController: AHRefreshControl?
    weak var pinVC: AHPinVC?
    weak var detailHandler: AHDetailHandler?
    var pinVMs: [AHPinViewModel]?
    
}



extension AHPinDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect item at indexPath:\(indexPath)")
        if indexPath.section == 1 {
            detailHandler?.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshController?.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshController?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        
    }
}









