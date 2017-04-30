//
//  AHPageLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/29/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPageLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    /// This function produce inconsistent slide photo experience
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let attributes = super.layoutAttributesForElements(in: collectionView!.bounds) {
            let half = collectionView!.bounds.width * 0.5
            let proposedOffsetCenterX = collectionView!.contentOffset.x + half
            
            let sortedAttributes = attributes.sorted(by: { (attrA, attrB) -> Bool in
                return abs(attrA.center.x - proposedOffsetCenterX) < abs(attrB.center.x - proposedOffsetCenterX)
            })
            
            let targetAttr = pickTheNextAttributes(attributs: sortedAttributes, velocity: velocity)
            
            return CGPoint(x: targetAttr.center.x - half, y: proposedContentOffset.y)
            
        }
        
        return CGPoint.zero
    }
    
    fileprivate func pickTheNextAttributes(attributs: [UICollectionViewLayoutAttributes],velocity: CGPoint) -> UICollectionViewLayoutAttributes {
        let target: UICollectionViewLayoutAttributes
        if attributs.count > 1 && abs(velocity.x) > 0.3 {
            // should scroll to next one
            let attr1 = attributs[0]
            let attr2 = attributs[1]
            if velocity.x > 0.0 {
                // scroll right, take the farthest one, relatively to future proposedOffsetCenterX
                target = attr1.center.x > attr2.center.x ? attr1 : attr2
            }else{
                // scroll left, take the nearest one, relatively to future proposedOffsetCenterX
                target = attr1.center.x < attr2.center.x ? attr1 : attr2
            }
        }else{
            // only one left, take this one
            target = attributs[0]
        }
        return target
    }
}
