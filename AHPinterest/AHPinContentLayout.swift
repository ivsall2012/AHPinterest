//
//  AHPinContentLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHPinContentDelegate: NSObjectProtocol {
    func AHPinContentSize(index: IndexPath) -> CGSize
}

class AHPinContentLayout: UICollectionViewLayout {
    weak var delegate: AHPinContentDelegate?
    var section: Int = -1
    var attributes: UICollectionViewLayoutAttributes?
    
    fileprivate var contentSize = CGSize.zero
}


extension AHPinContentLayout {
    override func prepare() {
        guard let delegate = delegate else {
            return
        }
        let index = IndexPath(item: 0, section: section)
        contentSize = delegate.AHPinContentSize(index: index)
        attributes = UICollectionViewLayoutAttributes(forCellWith: index)
        attributes?.frame.origin = CGPoint(x: 0, y: 0)
        attributes?.frame.size = CGSize(width: collectionView!.bounds.width, height: contentSize.height)
    }
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) ->[UICollectionViewLayoutAttributes]? {
        return [attributes!]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section == section else {
            return nil
        }
        return attributes
    }

    override func invalidateLayout() {
        attributes = nil
    }

}
