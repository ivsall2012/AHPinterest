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

extension AHDelegatesCenter: UICollectionViewDelegateFlowLayout {
    //************* START -> UICollectionViewDelegateFlowLayout  ****************
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if let collectionViewLayout = collectionViewLayout as? AHLayout {
            let section = collectionViewLayout.layoutSection
            let delegate = collectionVC.delegates[section]
            
            if let delegate = delegate as? UICollectionViewDelegateFlowLayout {
                return delegate.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize.zero
            }else{
                fatalError("Please make your delegate object comfirms to UICollectionViewDelegateFlowLayout")
            }
            
        }else{
            fatalError("Please use AHLayout")
        }
        
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let collectionViewLayout = collectionViewLayout as? AHLayout {
            let section = collectionViewLayout.layoutSection
            let delegate = collectionVC.delegates[section]
            
            if let delegate = delegate as? UICollectionViewDelegateFlowLayout {
                return delegate.collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? UIEdgeInsets.zero
            }else{
                fatalError("Please make your delegate object comfirms to UICollectionViewDelegateFlowLayout")
            }
            
        }else{
            fatalError("Please use AHLayout")
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let collectionViewLayout = collectionViewLayout as? AHLayout {
            let section = collectionViewLayout.layoutSection
            let delegate = collectionVC.delegates[section]
            
            if let delegate = delegate as? UICollectionViewDelegateFlowLayout {
                return delegate.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? CGFloat(0.0)
            }else{
                fatalError("Please make your delegate object comfirms to UICollectionViewDelegateFlowLayout")
            }
            
        }else{
            fatalError("Please use AHLayout")
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let collectionViewLayout = collectionViewLayout as? AHLayout {
            let section = collectionViewLayout.layoutSection
            let delegate = collectionVC.delegates[section]
            
            if let delegate = delegate as? UICollectionViewDelegateFlowLayout {
                return delegate.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? CGFloat(0.0)
            }else{
                fatalError("Please make your delegate object comfirms to UICollectionViewDelegateFlowLayout")
            }
            
        }else{
            fatalError("Please use AHLayout")
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let collectionViewLayout = collectionViewLayout as? AHLayout {
            let section = collectionViewLayout.layoutSection
            let delegate = collectionVC.delegates[section]
            
            if let delegate = delegate as? UICollectionViewDelegateFlowLayout {
                return delegate.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? CGSize.zero
            }else{
                fatalError("Please make your delegate object comfirms to UICollectionViewDelegateFlowLayout")
            }
            
        }else{
            fatalError("Please use AHLayout")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let collectionViewLayout = collectionViewLayout as? AHLayout {
            let section = collectionViewLayout.layoutSection
            let delegate = collectionVC.delegates[section]
            
            if let delegate = delegate as? UICollectionViewDelegateFlowLayout {
                return delegate.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section) ?? CGSize.zero
            }else{
                fatalError("Please make your delegate object comfirms to UICollectionViewDelegateFlowLayout")
            }
            
        }else{
            fatalError("Please use AHLayout")
        }
    }
    
    
    //************* END -> UICollectionViewDelegateFlowLayout ****************
    
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





