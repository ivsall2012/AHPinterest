//
//  AHLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/17/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHLayout: UICollectionViewLayout {
    private(set) weak var layoutRouter: AHLayoutRouter?
    var isGlobel = false
    override var collectionView: UICollectionView? {
        return layoutRouter?.collectionView ?? nil
    }
    var layoutSection: Int {
        return layoutRouter?.layoutSection(layout: self) ?? -1
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        // do nothing. In your subclass, do any nessesary cleanup, and invalidate layout through collectionView or layoutRouter!
    }
}
