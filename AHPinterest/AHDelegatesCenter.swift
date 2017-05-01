//
//  AHDelegatesCenter.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/16/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDelegatesCenter: NSObject {
    weak var collectionVC: AHCollectionVC!
    
    init(collectionVC: AHCollectionVC) {
        self.collectionVC = collectionVC
    }
}

extension AHDelegatesCenter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for delegate in collectionVC.generalDelegates {
            delegate.collectionView?(collectionView, didSelectItemAt: indexPath)
        }
        
        let delegate = collectionVC.delegates[indexPath.section]
        delegate.collectionView?(collectionView, didSelectItemAt: indexPath)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for delegate in collectionVC.generalDelegates {
            delegate.scrollViewDidScroll?(scrollView)
        }
        
        for delegate in collectionVC.delegates {
            delegate.scrollViewDidScroll?(scrollView)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for delegate in collectionVC.generalDelegates {
            delegate.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        for delegate in collectionVC.delegates {
            delegate.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
}





