//
//  AHLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHPinLayoutDelegate {
    func AHPinLayoutHeightForPhotoAt(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHPinLayoutHeightForNote(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHPinLayoutHeightForUserAvatar(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHPinLayoutSizeForHeader(collectionView: UICollectionView) -> CGSize?

}


class AHPinLayout: AHLayout {
    var delegate: AHPinLayoutDelegate!
    
    fileprivate var currentColumn: Int = 0
    
    fileprivate var columnWidth: CGFloat = 0.0
    
    fileprivate var xOffSets = [CGFloat]()
    
    fileprivate var yOffsets = [CGFloat](repeating: 0.0, count: AHNumberOfColumns)
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0.0

    fileprivate var contentWidth: CGFloat = 0.0
    
    fileprivate var headerAttributes : UICollectionViewLayoutAttributes?
    
    override class var layoutAttributesClass: AnyClass {
        return AHPinLayoutAttributes.self
    }
    
    
    fileprivate func reset() {
        guard let collectionView = collectionView else {
            return
        }
        
        currentColumn = 0
        contentHeight = 0.0
        let inset = collectionView.contentInset
        contentWidth = collectionView.bounds.width - (inset.left + inset.right)
        
        columnWidth = contentWidth / CGFloat(AHNumberOfColumns)
        
        xOffSets.removeAll()
        for i in 0..<AHNumberOfColumns {
            xOffSets.append(CGFloat(i) * columnWidth)
        }
        
        var unitYoffSet: CGFloat = 0.0
        if let headerSize = delegate.AHPinLayoutSizeForHeader(collectionView: collectionView) {
            unitYoffSet = headerSize.height
        }
        yOffsets = [CGFloat](repeating: unitYoffSet, count: AHNumberOfColumns)
    }
    
    
    
    fileprivate func prepareCell() {
        for i in 0..<collectionView!.numberOfItems(inSection: layoutSection) {
            let indexPath = IndexPath(item: i, section: layoutSection)
            insertAttributeIntoCache(indexPath: indexPath)
            
        }
    }
    
    fileprivate func prepareHeader() {
        guard let headerSize = delegate.AHPinLayoutSizeForHeader(collectionView: collectionView!) else {
            headerAttributes = nil
            return
        }
        if headerAttributes == nil {
            let index = IndexPath(item: 0, section: layoutSection)
            headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHPinLayoutHeaderKind, with: index)
            headerAttributes?.frame = .init(x: 0.0, y: 0.0, width: contentWidth, height: headerSize.height)
        }
    }
    
    override func prepare() {
//        super.prepare()
        guard cache.isEmpty else {
            return
        }
        reset()
        prepareCell()
        prepareHeader()
        
    }
    fileprivate func insertAttributeIntoCache(indexPath: IndexPath) {
        
        let cellWidth = columnWidth - 2 * AHCellPadding
        let imageHeight = delegate.AHPinLayoutHeightForPhotoAt(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        let noteHeight = delegate.AHPinLayoutHeightForNote(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        
        let userAvatarHeight = delegate.AHPinLayoutHeightForUserAvatar(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        let totalH = AHCellPadding + imageHeight + noteHeight + AHCellPadding + userAvatarHeight + AHCellPadding + AHCellPadding
        
        
        let attr = AHPinLayoutAttributes(forCellWith: indexPath)
        let cellX = xOffSets[currentColumn]
        let cellY = yOffsets[currentColumn]
        
        let frame = CGRect(x: cellX, y: cellY, width: columnWidth, height: totalH)
        let insetFrame = frame.insetBy(dx: AHCellPadding, dy: AHCellPadding)
        attr.frame = insetFrame
        attr.imageHeight = imageHeight
        attr.noteHeight = noteHeight
        cache.append(attr)
        
        
        let previousYOffSet = yOffsets[currentColumn]
        let currentYOffSet = previousYOffSet + totalH
        yOffsets[currentColumn] = currentYOffSet
        
        // Only change the stacking column when currentYOffSet is greater than previsouHeight, then we switch to next available cloumn
        contentHeight = max(frame.maxY, contentHeight)
        currentColumn = (indexPath.item) % AHNumberOfColumns
        
        
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard !cache.isEmpty else {
            return nil
        }
        var arr = [UICollectionViewLayoutAttributes]()
        for attr in cache {
            if isIntercept(attr: attr, rect: rect) {
                arr.append(attr)
            }
        }
        if let headerAttributes = headerAttributes {
            arr.append(headerAttributes)
        }
        return arr
        
    }
    
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = cache[indexPath.item]
        return attr
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == AHPinLayoutHeaderKind {
            return headerAttributes
        }
        return nil
    }
    
    
    override func invalidateLayout() {
//        super.invalidateLayout()
        cache.removeAll()
        reset()
    }
    
}















