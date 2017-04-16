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
        var currentOrigin = CGPoint.zero
        layoutArr.forEach { (layout) in
            let newRect = CGRect(x: rect.origin.x, y: currentOrigin.y + rect.origin.y, width: rect.size.width, height: rect.size.height)
            if let attrs = layout.layoutAttributesForElements(in: newRect) {
                let size = layout.collectionViewContentSize
                let newAttrs = attrs.map({ (attr) -> UICollectionViewLayoutAttributes in
                    return attr.copy() as! UICollectionViewLayoutAttributes
                })
                
                recaculateFrames(origin: currentOrigin, attributes: newAttrs)
                currentOrigin = CGPoint(x: 0.0, y: currentOrigin.y + size.height)
                attributes.append(contentsOf: newAttrs)
            }
        }
        return attributes
    }
    
    func recaculateFrames(origin offset: CGPoint, attributes array:[UICollectionViewLayoutAttributes]){
        for attr in array {
            attr.frame = mergeOrgins(orgin: offset, normal: attr.frame)
        }
    }
    
    func mergeOrgins(orgin offset: CGPoint, normal frame:CGRect) -> CGRect {
        return CGRect(x: frame.origin.x, y: offset.y + frame.origin.y, width: frame.size.width, height: frame.size.height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let layout = layoutArr[indexPath.section]
        let attr = layout.layoutAttributesForItem(at: indexPath)
        return attr
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layout = layoutArr[indexPath.section]
        let attr = layout.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        return attr
    }
    override func invalidateLayout() {
        super.invalidateLayout()
        contentSize = CGSize.zero
        layoutArr.forEach { (layout) in
            layout.invalidateLayout()
        }
    }
}
