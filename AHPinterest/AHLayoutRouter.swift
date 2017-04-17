//
//  AHLayoutRouter.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHLayoutRouterDelegate: NSObjectProtocol {
    func AHLayoutRouterHeaderSize(collectionView: UICollectionView, layoutRouter: AHLayoutRouter) -> CGSize
    func AHLayoutRouterFooterSize(collectionView: UICollectionView, layoutRouter: AHLayoutRouter) -> CGSize
}


class AHLayoutRouter: UICollectionViewLayout {
    // Public
    var enableHeaderRefresh = false {
        didSet {
            self.invalidateLayout()
        }
    }
    var enableFooterRefresh = false {
        didSet {
            self.invalidateLayout()
        }
    }
    weak var delegate: AHLayoutRouterDelegate?
    
    
    // Private
    fileprivate(set) var layoutArray = [UICollectionViewLayout]()
    fileprivate var routerAttributes = [UICollectionViewLayoutAttributes]()
    
    fileprivate var headerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHHeaderKind, with: AHHeaderIndexPath)
    fileprivate var footerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHFooterKind, with: AHFooterIndexPath)
    
    fileprivate var sectionOffsets = [CGFloat]()
    
}

extension AHLayoutRouter {
    func add(layout: UICollectionViewLayout) {
        layoutArray.append(layout)
        layout.setValue(self.collectionView, forKey: "collectionView")
        layout.setValue(layoutArray.count - 1, forKey: "section")
        invalidateLayout()
    }
    
    func remove(layout: UICollectionViewLayout){
        if let index = layoutArray.index(of: layout) {
            layoutArray.remove(at: index)
            invalidateLayout()
        }
    }
    
}

extension AHLayoutRouter {
    override func prepare() {
        layoutArray.forEach { (layout) in
            layout.prepare()
        }
        
        setupHeader()
    }
    
    /// For now, it only supports vertical direction layout. So the width of a contentSize is ignored
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView, layoutArray.count > 0 else {
            return CGSize.zero
        }
        sectionOffsets.removeAll()
        var totalHeight: CGFloat = 0.0
        layoutArray.forEach { (layout) in
            sectionOffsets.append(totalHeight)
            let height = layout.collectionViewContentSize.height
            totalHeight += height
            
        }
        let inset = collectionView.contentInset
        let insetOffset = (inset.left + inset.right)
        let width = collectionView.bounds.width - insetOffset
        return CGSize(width: width, height: totalHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        var currentOffset = CGPoint.zero
        
        // Loop through layouts and make offset for their attributes
        layoutArray.forEach { (layout) in
            let newRect = CGRect(x: rect.origin.x, y: rect.origin.y - currentOffset.y, width: rect.size.width, height: rect.size.height)
            if let attrs = layout.layoutAttributesForElements(in: newRect) {
                let newAttrs = attrs.map({ (attr) -> UICollectionViewLayoutAttributes in
                    return attr.copy() as! UICollectionViewLayoutAttributes
                })

                normalizeAttributes(offset: currentOffset, attributes: newAttrs)
                attributes.append(contentsOf: newAttrs)
            }
            
            let size = layout.collectionViewContentSize
            currentOffset = CGPoint(x: 0.0, y: currentOffset.y + size.height)
        }
        
        attributes.append(contentsOf: routerAttributes)
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let sectionOffset = sectionOffsets[indexPath.section]
        let offset = CGPoint(x: 0.0, y: sectionOffset)
        let layout = layoutArray[indexPath.section]
        if let attr = layout.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            normalizeAttributes(offset: offset, attributes: [attr])
            return attr
        }
        
        return nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == AHHeaderKind && self.enableHeaderRefresh {
            return headerAttr
        }else if elementKind == AHFooterKind && self.enableFooterRefresh{
            return footerAttr
        }else{
            let layout = layoutArray[indexPath.section]
            let attr = layout.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
             return attr
        }
        
    }

    
    override func invalidateLayout() {
        super.invalidateLayout()
        headerAttr.frame = .zero
        footerAttr.frame = .zero
        layoutArray.forEach { (layout) in
            layout.invalidateLayout()
        }
    }
}



// MARK:- Private Methods
extension AHLayoutRouter {
    fileprivate func normalizeAttributes(offset: CGPoint, attributes array:[UICollectionViewLayoutAttributes]){
        for attr in array {
            attr.frame = normalizeAttributes(offset: offset, frame: attr.frame)
            
        }
    }
    
    fileprivate func normalizeAttributes(offset: CGPoint, frame:CGRect) -> CGRect {
        return CGRect(x: frame.origin.x, y: offset.y + frame.origin.y, width: frame.size.width, height: frame.size.height)
    }
    
    
    fileprivate func setupHeader() {
        guard let delegate = delegate, let collectionView = collectionView else {
            return
        }
        routerAttributes.removeAll()
        
        let inset = collectionView.contentInset
        
        let headerRawSize = delegate.AHLayoutRouterHeaderSize(collectionView: collectionView, layoutRouter: self)
        if headerRawSize != CGSize.zero && self.enableHeaderRefresh {
            let headerOrigin = CGPoint(x: 0.0, y: -headerRawSize.height + inset.top)
            let headerSize = CGSize(width: collectionViewContentSize.width, height: headerRawSize.height)
            headerAttr.frame = .init(origin: headerOrigin, size: headerSize)
            routerAttributes.append(headerAttr)
        }
        
        // contentHeight is set alraedy since prepareCell() is called before this func
        // all cells needed to be calculated in order to obtain contentHeight
        let footerRawSize = delegate.AHLayoutRouterFooterSize(collectionView: collectionView, layoutRouter: self)
        if footerRawSize != CGSize.zero && self.enableFooterRefresh {
            let footerOrigin = CGPoint(x: 0.0, y: collectionViewContentSize.height)
            let footerSize = CGSize(width: collectionViewContentSize.width, height: footerRawSize.height)
            footerAttr.frame = .init(origin: footerOrigin, size: footerSize)
            routerAttributes.append(footerAttr)
        }

    
    }
}





