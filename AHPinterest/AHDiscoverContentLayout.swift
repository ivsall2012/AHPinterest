//
//  AHDiscoverContentLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 5/1/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHDiscoverContentLayoutDelegate: NSObjectProtocol {
    func discoverContentLayoutForContentHeight(layout: AHDiscoverContentLayout) -> CGFloat
}

class AHDiscoverContentLayout: AHLayout {
    weak var delegate: AHDiscoverContentLayoutDelegate?
    
    fileprivate var attributes: UICollectionViewLayoutAttributes?
    override func prepare() {
        let indexPath = IndexPath(item: 0, section: self.layoutSection)
        attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    }
    
    override var collectionViewContentSize: CGSize {
        let height = delegate!.discoverContentLayoutForContentHeight(layout: self)
        let size = CGSize(width: 0.0, height: height)
        let width = collectionView!.bounds.width - (collectionView!.contentInset.left + collectionView!.contentInset.right)
        attributes?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if isIntercept(attr: attributes!, rect: rect) {
            return [attributes!]
        }else{
            return nil
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section == self.layoutSection {
            return attributes
        }else{
            return nil
        }
    }

}
