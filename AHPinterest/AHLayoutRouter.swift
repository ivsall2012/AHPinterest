//
//  AHLayoutRouter.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit




class AHLayoutRouter: UICollectionViewLayout {
    // Contains cell and section supplement layouts
    fileprivate(set) var layoutArray = [AHLayout]()
    // Contains globel suppelements layouts
    fileprivate(set) var globelSupplements = [AHLayout]()
    // Contains each the y orgin layout in layoutArray
    fileprivate var sectionYorigins = [CGFloat]()
    
}

// MARK:- Public API
extension AHLayoutRouter {
    
    
    /// This method will add the layout's cell attributes with a normolization for their 'local' frames which means you calculate your layout, within your section, based on the top left corner point (0,0) -- local level. And layoutRouter will later normalize your attributes' frames relative to the built-in collectionView -- globel level, in order for mutiple layouts to work smoothly.
    /// - parameter layout: Provides cell or local supplement attributes
    func add(layout: AHLayout) {
        layoutArray.append(layout)
        layout.setValue(self, forKey: "layoutRouter")
        invalidateLayout()
    }
    
    /// This method will add the layout's supplement attributes without any normolization for their frames. Your supplement attributes will be shown for the whole collectionView.
    /// - parameter layout: Provides globel supplement attributes
    func addGlobelSupplement(layout: AHLayout) {
        globelSupplements.append(layout)
        layout.setValue(self, forKey: "layoutRouter")
        invalidateLayout()
    }
    
    func remove(layout: AHLayout){
        if let index = layoutArray.index(of: layout) {
            layoutArray.remove(at: index)
            invalidateLayout()
        }
    }
    
    func removeGlobelSupplement(layout: AHLayout) {
        if let index = globelSupplements.index(of: layout) {
            globelSupplements.remove(at: index)
            invalidateLayout()
        }
    }
    
    
    /// Return the layout's current section. If the layout is regular cell layout, wihtin/without supplement attributes included, the section number is the order being added to the layoutRouter, or the position in router's layourArray. Globel supplement layouts, the section number is layoutArray.count + position in globelSupplements -- it's always greater than any regular layout's section number.
    ///
    /// - parameter layout: can be regular layout or supplement layout, will check all
    ///
    /// - returns: the layout's current section
    func layoutSection(layout: AHLayout) -> Int {
        if let index = layoutArray.index(of: layout) {
            return index
        }
        if let index = globelSupplements.index(of: layout) {
            return layoutArray.count + index
        }
        return -1
    }
    
}


// MARK:- Layout Cycle
extension AHLayoutRouter {
    override func prepare() {
        layoutArray.forEach { (layout) in
            layout.prepare()
        }
        
        globelSupplements.forEach { (layout) in
            layout.prepare()
        }

    }
    
    /// For now, it only supports vertical direction layout. So the width of a contentSize is ignored
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView, layoutArray.count > 0 else {
            return CGSize.zero
        }
        sectionYorigins.removeAll()
        var totalHeight: CGFloat = 0.0
        layoutArray.forEach { (layout) in
            sectionYorigins.append(totalHeight)
            let height = layout.collectionViewContentSize.height
            totalHeight += height
            
        }
        let inset = collectionView.contentInset
        let insetOffset = (inset.left + inset.right)
        let width = collectionView.bounds.width - insetOffset
        print("sectionYorigins:\(sectionYorigins)")
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
        
        globelSupplements.forEach { (layout) in
            // it's globel, so no normalization needed
            if let attrs = layout.layoutAttributesForElements(in: rect) {
                attributes.append(contentsOf: attrs)
            }
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let sectionOffset = sectionYorigins[indexPath.section]
        let offset = CGPoint(x: 0.0, y: sectionOffset)
        let layout = layoutArray[indexPath.section]
        if let attr = layout.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            normalizeAttributes(offset: offset, attributes: [attr])
            return attr
        }
        
        return nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layout = globelSupplements[indexPath.section]
        let attr = layout.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        return attr
        
    }

    
    override func invalidateLayout() {
        super.invalidateLayout()
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
    
    
    
}





