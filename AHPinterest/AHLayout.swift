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
    
    
}


class AHLayout: UICollectionViewLayout {
    var delegate: AHLayoutDelegate!
    

    
    
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
//    
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











