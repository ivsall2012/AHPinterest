//
//  AHLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHLayoutAttributes: UICollectionViewLayoutAttributes {
    var imageHeight: CGFloat = 0.0
    var noteHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! AHLayoutAttributes
        copy.imageHeight = self.imageHeight
        copy.noteHeight = self.noteHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let otherObj = object as? AHLayoutAttributes{
            if (otherObj.imageHeight - self.imageHeight) < 0.01 && (otherObj.noteHeight - self.noteHeight) < 0.01{
                return super.isEqual(otherObj)
            }
        }else{
            return false
        }
        return false
    }
}

protocol AHLayoutDelegate {
    func AHLayoutHeightForPhotoAt(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHLayoutHeightForNote(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHLayoutHeightForUserAvatar(indexPath: IndexPath, width: CGFloat, collectionView: UICollectionView) -> CGFloat
    
    func AHLayoutSizeForHeaderView() -> CGSize
    
    func AHLayoutSizeForFooterView() -> CGSize
}


class AHPinLayout: UICollectionViewLayout {
    var delegate: AHLayoutDelegate!
    var activateRefreshControl: Bool = false
    fileprivate var isRefreshSetup: Bool = false
    
    fileprivate var headerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHHeaderKind, with: IndexPath(item: 0, section: 0))
    fileprivate var footerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHFooterKind, with: IndexPath(item: 1, section: 0))
    
    
    fileprivate var currentMaxYOffset: CGFloat = 0.0
    
    fileprivate var currentColumn: Int = 0
    
    fileprivate var columnWidth: CGFloat = 0.0
    
    fileprivate var xOffSets = [CGFloat]()
    
    fileprivate var yOffsets = [CGFloat](repeating: 0.0, count: AHNumberOfColumns)
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0.0

    fileprivate var contentWidth: CGFloat = 0.0
    
    override class var layoutAttributesClass: AnyClass {
        return AHLayoutAttributes.self
    }
    
    
    fileprivate func reset() {
        currentMaxYOffset = 0.0
        currentColumn = 0
        contentHeight = 0.0
//        let inset = collectionView?.contentInset
        let inset = AHCollectionViewInset
//        contentWidth = collectionView!.bounds.width - (inset!.left + inset!.right)
        contentWidth = UIScreen.main.bounds.width - (inset.left + inset.right)
        
        columnWidth = contentWidth / CGFloat(AHNumberOfColumns)
        
        xOffSets.removeAll()
        for i in 0..<AHNumberOfColumns {
            xOffSets.append(CGFloat(i) * columnWidth)
        }
        
        yOffsets = [CGFloat](repeating: 0.0, count: AHNumberOfColumns)
    }
    
    fileprivate func setupHeader() {
        if isRefreshSetup {
            return
        }

        let inset = collectionView?.contentInset
        let headerRawSize = delegate.AHLayoutSizeForHeaderView()
        let headerOrigin = CGPoint(x: 0.0, y: -headerRawSize.height + inset!.top)
        let headerSize = CGSize(width: contentWidth, height: headerRawSize.height)
        headerAttr.frame = .init(origin: headerOrigin, size: headerSize)
        
        // contentHeight is set alraedy since prepareCell() is called before this func
        // all cells needed to be calculated in order to obtain contentHeight
        let footerRawSize = delegate.AHLayoutSizeForFooterView()
        let footerOrigin = CGPoint(x: 0.0, y: contentHeight)
        let footerSize = CGSize(width: contentWidth, height: footerRawSize.height)
        footerAttr.frame = .init(origin: footerOrigin, size: footerSize)

        
        
        if activateRefreshControl {
            cache.append(headerAttr)
            cache.append(footerAttr)
        }else{
            cache = cache.filter({ (attr) -> Bool in
                if attr != headerAttr || attr != footerAttr {
                    return true
                }else{
                    return false
                }
            })
        }
        
        isRefreshSetup = true
    }
    
    fileprivate func prepareCell() {
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            insertAttributeIntoCache(indexPath: indexPath)
            
        }
    }
    
    
    override func prepare() {
//        super.prepare()
        guard cache.isEmpty else {
            return
        }
        reset()
        prepareCell()
        
        // setupHeader has to be called so that headerAttr is at the end of the cache array -- in order to display(weird!)
        setupHeader()
        
        
        
    }
    func insertAttributeIntoCache(indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            fatalError("There can be only 1 section at this time")
        }
        
        let cellWidth = columnWidth - 2 * AHCellPadding
        let imageHeight = delegate.AHLayoutHeightForPhotoAt(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        let noteHeight = delegate.AHLayoutHeightForNote(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        
        let userAvatarHeight = delegate.AHLayoutHeightForUserAvatar(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
        
        let totalH = AHCellPadding + imageHeight + noteHeight + AHCellPadding + userAvatarHeight + AHCellPadding + AHCellPadding
        
        
        let attr = AHLayoutAttributes(forCellWith: indexPath)
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
        if currentMaxYOffset < currentYOffSet {
            currentMaxYOffset = currentYOffSet
            // update column for next round only when current column is taller than the other one. FYI: column values are only 0,1
            currentColumn = (indexPath.item + 1) % AHNumberOfColumns
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
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == AHHeaderKind {
            return headerAttr
        }else if elementKind == AHFooterKind{
            return footerAttr
        }else{
            return nil
        }
    }
    
    func isIntercept(attr: UICollectionViewLayoutAttributes, rect: CGRect) -> Bool {
        return rect.intersects(attr.frame)
    }
    
    
    
    override func invalidateLayout() {
//        super.invalidateLayout()
        cache.removeAll()
        isRefreshSetup = false
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















