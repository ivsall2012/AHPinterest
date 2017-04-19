//
//  AHPinContentLayout.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHPinContentLayoutDelegate: NSObjectProtocol {
    func pinDetailLayoutNoteHeight(font: UIFont, width: CGFloat) -> CGFloat
    func pinDetailLayoutImageHeight(width: CGFloat) -> CGFloat
}

class AHPinContentLayout: AHLayout {
    weak var delegate: AHPinContentLayoutDelegate?
    let noteFont = UIFont.systemFont(ofSize: 20.0)
    fileprivate var attributes: AHPinLayoutAttributes?
    fileprivate var contentSize = CGSize.zero
}

// MARK:- Layout Cycle
extension AHPinContentLayout {
    override func prepare() {
        guard let delegate = delegate else {
            return
        }
        let index = IndexPath(item: 0, section: layoutSection)
        let inset = collectionView!.contentInset
        let cellWidth:CGFloat = collectionView!.bounds.width - (inset.left + inset.right)
        let noteHeight:CGFloat = delegate.pinDetailLayoutNoteHeight(font: noteFont, width: cellWidth)
        let imageHeight:CGFloat = delegate.pinDetailLayoutImageHeight(width: cellWidth)
        let avatarHeight:CGFloat = 50.0
        let totalHeight = noteHeight + imageHeight + AHCellPadding + avatarHeight + AHCellPadding
        
        attributes = AHPinLayoutAttributes(forCellWith: index)
        attributes!.frame.origin = CGPoint(x: 0, y: 0)
        attributes!.frame.size = CGSize(width: cellWidth, height: totalHeight)
        
        attributes!.imageHeight = imageHeight
        attributes?.noteHeight = noteHeight
        
        contentSize = .init(width: 0.0, height: totalHeight)
    }
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) ->[UICollectionViewLayoutAttributes]? {
        return [attributes!]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes
    }

    override func invalidateLayout() {
        attributes?.frame = .zero
    }

}
