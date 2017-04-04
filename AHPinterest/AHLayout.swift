//
//  AHLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAt indexPath: IndexPath,with width: CGFloat) -> CGFloat
}


class AHLayout: UICollectionViewLayout {
    var delegate: AHLayoutDelegate!
    
    var numberOfColumns: Int = 2
    var cellPadding : CGFloat = 6.0
    
    
    private var cache = [AHLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let inset = collectionView?.contentInset
        return collectionView!.bounds.width - (inset!.left + inset!.right)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return AHLayoutAttributes.self
    }
    
    
    override func prepare() {
        guard cache.isEmpty else {
            return
        }
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        var xOffSets = [CGFloat]()
        for i in 0..<numberOfColumns {
            xOffSets.append(CGFloat(i) * columnWidth)
        }
        
        var column: Int = 0
        var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
        var previousHeight: CGFloat = 0.0
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            
            let cellW = columnWidth - 2 * cellPadding
            let photoHeight = delegate.collectionView(collectionView: collectionView!, heightForPhotoAt: indexPath, with: cellW)
            let annotationHeight = delegate.collectionView(collectionView: collectionView!, heightForAnnotationAt: indexPath, with: cellW)
            let totalH = cellPadding + photoHeight + annotationHeight + cellPadding + 10
            
            
            let attr = AHLayoutAttributes(forCellWith: indexPath)
            let cellX = xOffSets[column]
            let cellY = yOffsets[column]
            
            let frame = CGRect(x: cellX, y: cellY, width: columnWidth, height: totalH)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            attr.frame = insetFrame
            attr.photoHeight = photoHeight
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
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard !cache.isEmpty else {
            return nil
        }
        var arr = [AHLayoutAttributes]()
        for attr in cache {
            arr.append(attr)
        }
        return arr
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForItem(at: indexPath) as! AHLayoutAttributes
        if cache.contains(attr) {
            print("ok")
        }
        
        
        return attr
    }
    
}











