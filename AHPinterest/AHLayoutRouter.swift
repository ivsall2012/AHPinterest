//
//  AHLayoutRouter.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHLayoutRouter: UICollectionViewLayout {
    fileprivate var layoutArr = [UICollectionViewLayout]()
    var contentSize = CGSize.zero
}

extension AHLayoutRouter {
    func add(layout: UICollectionViewLayout) {
        layoutArr.append(layout)
        layout.setValue(self.collectionView, forKey: "collectionView")
        invalidateLayout()
    }
    
    func remove(layout: UICollectionViewLayout){
        if let index = layoutArr.index(of: layout) {
            layoutArr.remove(at: index)
            invalidateLayout()
        }
    }
}

extension AHLayoutRouter {
    override func prepare() {
        layoutArr.forEach { (layout) in
            layout.prepare()
        }
    }
    override var collectionViewContentSize: CGSize {
        contentSize = CGSize.zero
        layoutArr.forEach { (layout) in
            let newSize = CGSize(width: layout.collectionViewContentSize.width + self.contentSize.width, height: layout.collectionViewContentSize.height + self.contentSize.height)
            self.contentSize = newSize
        }
        return self.contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        layoutArr.forEach { (layout) in
            if let attrs = layout.layoutAttributesForElements(in: rect) {
                attributes.append(contentsOf: attrs)
            }
        }
        return attributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var targetAttr: UICollectionViewLayoutAttributes?
        layoutArr.forEach { (layout) in
            if targetAttr == nil {
                targetAttr = layout.layoutAttributesForItem(at: indexPath)
            }
        }
        if targetAttr == nil {
            fatalError("targetAttr can't nil")
        }
        return targetAttr
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var targetAttr: UICollectionViewLayoutAttributes?
        layoutArr.forEach { (layout) in
            if targetAttr != nil {
                targetAttr = layout.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
            }
        }
        return targetAttr
    }
    override func invalidateLayout() {
        super.invalidateLayout()
        contentSize = CGSize.zero
        layoutArr.forEach { (layout) in
            layout.invalidateLayout()
        }
    }
}
