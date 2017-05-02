//
//  AHDiscoverContentLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 5/1/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit







class AHDiscoverContentLayout: AHLayout {
    var cache = [UICollectionViewLayoutAttributes]()
    var totalHeight:CGFloat = 0.0
    override func prepare() {
        cache.removeAll()
        let layoutSection = self.layoutSection
        if let numberOfItems = collectionView?.numberOfItems(inSection: layoutSection), numberOfItems > 0 {
            let fixedColumn = 2
            let totalWidth = collectionView!.bounds.width - (collectionView!.contentInset.left + collectionView!.contentInset.right)
            let paddingSpace:CGFloat = 16
            let cellWidth = (totalWidth - (CGFloat((fixedColumn + 1)) * paddingSpace)) / CGFloat(fixedColumn)
            let cellSize = CGSize(width: cellWidth, height: 200)
            
            let unitWidth = paddingSpace + cellSize.width
            let unitHeight = cellSize.height + paddingSpace
            
            
            
            for i in 0..<numberOfItems {
                let indexPath = IndexPath(item: i, section: layoutSection)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let column:Int = i % fixedColumn
                let row:Int = i / fixedColumn
                let x: CGFloat = paddingSpace + CGFloat(column) * unitWidth
                let y:CGFloat = paddingSpace + CGFloat(row) * unitHeight
                attr.frame = CGRect(x: x, y: y, width: cellSize.width, height: cellSize.height)

                cache.append(attr)
                
            }
            
            totalHeight = CGFloat((numberOfItems - 1) / fixedColumn + 1) * unitHeight
        }
        
        
        
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0.0, height: totalHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = cache.filter { (attr) -> Bool in
            return isIntercept(attr: attr, rect: rect)
        }
        
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section == self.layoutSection {
            return cache[indexPath.item]
        }else{
            fatalError("Router error: received unmatch layoutSection")
        }
    }

    override func invalidateLayout() {
        cache.removeAll()
        totalHeight = 0.0
    }
}
