//
//  AHPinContentLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHPinDetailLayoutDelegate: NSObjectProtocol {
    func AHPinDetailLayoutSize(index: IndexPath) -> CGSize
}

class AHPinDetailLayout: AHLayout {
    weak var delegate: AHPinDetailLayoutDelegate?
    
    fileprivate var attributes: UICollectionViewLayoutAttributes?
    fileprivate var contentSize = CGSize.zero
}

// MARK:- Layout Cycle
extension AHPinDetailLayout {
    override func prepare() {
        guard let delegate = delegate else {
            return
        }
        let index = IndexPath(item: 0, section: layoutSection)
        contentSize = delegate.AHPinDetailLayoutSize(index: index)
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
        return attributes
    }

    override func invalidateLayout() {
        attributes?.frame = .zero
    }

}
