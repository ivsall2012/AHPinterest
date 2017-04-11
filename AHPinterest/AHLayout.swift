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
    
    /// Cand do refresh control animations here
    func AHLayoutNotifyScroll(collectionView: UICollectionView, contentSize: CGSize)
    
}


class AHLayout: UICollectionViewLayout {
    var delegate: AHLayoutDelegate!

    private var isHeaderSetup: Bool = false
    private var headerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: AHCollectionRefreshHeaderKind, with: IndexPath(item: 0, section: 0))
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let inset = collectionView?.contentInset
        return collectionView!.bounds.width - (inset!.left + inset!.right)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return AHLayoutAttributes.self
    }
    fileprivate func setupHeader() {
        if isHeaderSetup {
            return
        }
        let headerSize = delegate.AHLayoutSizeForHeaderView()
        let origin = CGPoint(x: 0.0, y: -headerSize.height)
        let size = CGSize(width: (collectionView?.bounds.width)!, height: headerSize.height)
        headerAttr.frame = .init(origin: origin, size: size)
        
        isHeaderSetup = true
    }
    
    fileprivate func prepareCell() {
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        var xOffSets = [CGFloat]()
        for i in 0..<numberOfColumns {
            xOffSets.append(CGFloat(i) * columnWidth)
        }
        
        var column: Int = 0
        var yOffsets = [CGFloat](repeating: 0.0, count: numberOfColumns)
        var previousHeight: CGFloat = 0.0
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            
            let cellWidth = columnWidth - 2 * cellPadding
            let imageHeight = delegate.AHLayoutHeightForPhotoAt(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
            
            let noteHeight = delegate.AHLayoutHeightForNote(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
            
            
            let userAvatarHeight = delegate.AHLayoutHeightForUserAvatar(indexPath: indexPath, width: cellWidth, collectionView: collectionView!)
            
            let totalH = cellPadding + imageHeight + noteHeight + cellPadding + userAvatarHeight + cellPadding + cellPadding
            
            
            let attr = AHLayoutAttributes(forCellWith: indexPath)
            let cellX = xOffSets[column]
            let cellY = yOffsets[column]
            
            let frame = CGRect(x: cellX, y: cellY, width: columnWidth, height: totalH)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            attr.frame = insetFrame
            attr.imageHeight = imageHeight
            attr.noteHeight = noteHeight
            cache.append(attr)

            let previousYOffSet = yOffsets[column]
            let currentYOffSet = previousYOffSet + totalH
            yOffsets[column] = currentYOffSet
            
            // Only change the stacking column when currentYOffSet is greater than previsouHeight, then we switch to next available cloumn
            contentHeight = max(frame.maxY, contentHeight)
            if previousHeight < currentYOffSet {
                previousHeight = currentYOffSet
                column = i % numberOfColumns
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        guard cache.isEmpty else {
            return
        }
        prepareCell()
        // setupHeader has to be called so that headerAttr is at the end of the cache array -- in order to display(weird!)
        setupHeader()
        cache.append(headerAttr)
        
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
        
        if let collectionView = collectionView {
            let size = self.collectionViewContentSize
            delegate.AHLayoutNotifyScroll(collectionView: collectionView, contentSize: size)
        }
        
        return arr
        
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
        self.cache.removeAll()
        self.isHeaderSetup = false
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











