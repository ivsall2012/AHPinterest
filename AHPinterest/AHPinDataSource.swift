//
//  AHPinDataSource.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/13/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinDataSource: NSObject {
    weak var pinVC: AHPinVC?
    weak var refreshController: AHRefreshControl?
    var pinVMs: [AHPinViewModel]?
    
}

extension AHPinDataSource : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinVMs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pinCell = collectionView.dequeueReusableCell(withReuseIdentifier: AHPinCellIdentifier, for: indexPath) as! AHPinCell
        guard let pinVMs = pinVMs else {
            return pinCell
        }
        
        let pinVM = pinVMs[indexPath.item]
        
        pinCell.pinVM = pinVM
        return pinCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == AHHeaderKind {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: AHHeaderKind, withReuseIdentifier: AHHeaderKind, for: indexPath) as! AHRefreshHeader
            refreshController?.headerCell = header
            return header
        }else if kind == AHFooterKind{
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: AHFooterKind, withReuseIdentifier: AHFooterKind, for: indexPath) as! AHRefreshFooter
            refreshController?.footerCell = footer
            return footer
        }else{
            return UICollectionReusableView()
        }
    }
    
    
}
