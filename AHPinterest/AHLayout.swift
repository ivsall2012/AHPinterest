//
//  AHLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit



protocol AHLayoutDelegate {
    func AHLayoutHeightForPhotoAt(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHLayoutHeightForNote(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHLayoutHeightForUserAvatar(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHLayoutSizeForHeaderView() -> CGSize
    
}


class AHLayout: UICollectionViewLayout {
    var delegate: AHLayoutDelegate!

    fileprivate var isHeaderSetup: Bool = false
    fileprivate var headerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHCollectionRefreshHeaderKind, with: IndexPath(item: 0, section: 0))
    
    fileprivate var currentMaxYOffset: CGFloat = 0.0
    
    fileprivate var currentColumn: Int = 0
    
    fileprivate var columnWidth: CGFloat = 0.0
    
    fileprivate var xOffSets = [CGFloat]()
    
    fileprivate var yOffsets = [CGFloat](repeating: 0.0, count: numberOfColumns)
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0.0

    fileprivate var contentWidth: CGFloat = 0.0
    
    override class var layoutAttributesClass: AnyClass {
        return AHLayoutAttributes.self
    }
    
    
    fileprivate func reset() {
        currentMaxYOffset = 0.0
        currentColumn = 0
        
        let inset = collectionView?.contentInset
        contentWidth = collectionView!.bounds.width - (inset!.left + inset!.right)
        
        columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        xOffSets.removeAll()
        for i in 0..<numberOfColumns {
            xOffSets.append(CGFloat(i) * columnWidth)
        }
        
        yOffsets = [CGFloat](repeating: 0.0, count: numberOfColumns)
    }
    
    fileprivate func setupHeader() {
        if isHeaderSetup {
            return
        }
        let inset = collectionView?.contentInset
        let headerSize = delegate.AHLayoutSizeForHeaderView()
        let origin = CGPoint(x: 0.0, y: -headerSize.height + inset!.top)
        let size = CGSize(width: contentWidth, height: headerSize.height)
        headerAttr.frame = .init(origin: origin, size: size)
        isHeaderSetup = true
    }
    
    fileprivate func prepareCell() {
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            insertAttributeIntoCache(indexPath: indexPath)
            
        }
    }
    
    
    override func prepare() {
        super.prepare()
        guard cache.isEmpty else {
            return
        }
        reset()
        prepareCell()
        // setupHeader has to be called so that headerAttr is at the end of the cache array -- in order to display(weird!)
        setupHeader()
        cache.append(headerAttr)
        
    }
    func insertAttributeIntoCache(indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            fatalError("There can be only 1 section at this time")
        }
        
        let cellWidth = columnWidth - 2 * cellPadding
        let imageHeight = delegate.AHLayoutHeightForPhotoAt(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        let noteHeight = delegate.AHLayoutHeightForNote(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        
        let userAvatarHeight = delegate.AHLayoutHeightForUserAvatar(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        let totalH = cellPadding + imageHeight + noteHeight + cellPadding + userAvatarHeight + cellPadding + cellPadding
        
        
        let attr = AHLayoutAttributes(forCellWith: indexPath)
        let cellX = xOffSets[currentColumn]
        let cellY = yOffsets[currentColumn]
        
        let frame = CGRect(x: cellX, y: cellY, width: columnWidth, height: totalH)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        attr.frame = insetFrame
        attr.imageHeight = imageHeight
        attr.noteHeight = noteHeight
        cache.append(attr)
        
        
        let previousYOffSet = yOffsets[currentColumn]
        let currentYOffSet = previousYOffSet + totalH
        yOffsets[currentColumn] = currentYOffSet
        
        // Only change the stacking column when currentYOffSet is greater than previsouHeight, then we switch to next available cloumn
        contentHeight = max(frame.maxY, contentHeight)
        if currentMaxYOffset < currentYOffSet {
            currentMaxYOffset = currentYOffSet
            // update column for next round only when current column is taller than the other one. FYI: column values are only 0,1
            currentColumn = (indexPath.item + 1) % numberOfColumns
        }
        
        // TODO: if there are more than 2 column to display, new pins should be distributed to the shortest yOffset column in order to best even out the heights across all columns
        
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
        return arr
        
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = cache[indexPath.item]
        return attr
    }
    
    
    func isIntercept(attr: UICollectionViewLayoutAttributes, rect: CGRect) -> Bool {
        return rect.intersects(attr.frame)
    }
    
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == AHCollectionRefreshHeaderKind {
            return headerAttr
        }
        return nil
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        isHeaderSetup = false
        reset()
    }
    
//    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        print("initialLayoutAttributesForAppearingSupplementaryElement")
//        return headerAttr
//    }
    
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attr = super.layoutAttributesForItem(at: indexPath) as! AHLayoutAttributes
//        if cache.contains(attr) {
//            print("ok")
//        }else{
//            print("not ok")
//        }
//        
//        
//        return attr
//    }
    
}











