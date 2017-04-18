//
//  AHRefreshLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/17/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHRefreshLayoutDelegate: NSObjectProtocol {
    func AHRefreshLayoutHeaderSize(collectionView: UICollectionView, layout: AHLayout) -> CGSize
    func AHRefreshLayoutFooterSize(collectionView: UICollectionView, layout: AHLayout) -> CGSize
}

class AHRefreshLayout: AHLayout {
    weak var delegate: AHRefreshLayoutDelegate?
    
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
    
    // Private
    fileprivate var headerAttr: UICollectionViewLayoutAttributes?
    fileprivate var footerAttr: UICollectionViewLayoutAttributes?
    
    func createAttributes() {
        let AHHeaderIndexPath = IndexPath(item: 0, section: layoutSection)
        let AHFooterIndexPath = IndexPath(item: 1, section: layoutSection)
        headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHHeaderKind, with: AHHeaderIndexPath)
        footerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHFooterKind, with: AHFooterIndexPath)
    }
}



// MARK:- Layout Cycle
extension AHRefreshLayout {
    override func prepare() {
        createAttributes()
        setupHeader()
        
    }
    override var collectionViewContentSize: CGSize {
        // since the refresh header/footer doesn't actually occupy any space till they are being dragged. They don't affect those main layouts' frames. Refreshes' sizes are determined by their attributes' frames(headerAttr,footerAttr)
        return CGSize.zero
    }
    
    override func layoutAttributesForElements(in rect: CGRect) ->[UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if self.enableHeaderRefresh && isIntercept(attr: headerAttr!, rect: rect) {
            attributes.append(headerAttr!)
        }
        if self.enableFooterRefresh && isIntercept(attr: footerAttr!, rect: rect) {
            attributes.append(footerAttr!)
        }
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == AHHeaderKind && self.enableHeaderRefresh {
            return headerAttr
        }else if elementKind == AHFooterKind && self.enableFooterRefresh{
            return footerAttr
        }
        return nil
    }
    override func invalidateLayout() {
        
    }
    
}



// MARK:- Private Methods
extension AHRefreshLayout {
    fileprivate func setupHeader() {
        guard let delegate = delegate, let collectionView = collectionView else {
            return
        }
        
        let inset = collectionView.contentInset
        let contentSize = layoutRouter?.collectionViewContentSize ?? .zero
        let headerRawSize = delegate.AHRefreshLayoutHeaderSize(collectionView: collectionView, layout: self)
        if headerRawSize != CGSize.zero && self.enableHeaderRefresh {
            let headerOrigin = CGPoint(x: 0.0, y: -headerRawSize.height + inset.top)
            let headerSize = CGSize(width: contentSize.width, height: headerRawSize.height)
            headerAttr!.frame = .init(origin: headerOrigin, size: headerSize)
        }
        
        let footerRawSize = delegate.AHRefreshLayoutFooterSize(collectionView: collectionView, layout: self)
        if footerRawSize != CGSize.zero && self.enableFooterRefresh {
            let footerOrigin = CGPoint(x: 0.0, y: contentSize.height)
            let footerSize = CGSize(width: contentSize.width, height: footerRawSize.height)
            footerAttr!.frame = .init(origin: footerOrigin, size: footerSize)
        }
        
        
    }
}



