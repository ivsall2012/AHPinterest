//
//  AHPinContentHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinContentLayoutHandler: NSObject {
    var contentSize = CGSize.zero
    weak var pinVM: AHPinViewModel?
    var presentingCell: AHPinContentCell?
    weak var pinContentVC: AHPinContentVC?
}

extension AHPinContentLayoutHandler: AHPinContentLayoutDelegate {
    func pinDetailLayoutImageHeight(width: CGFloat) -> CGFloat {
        guard let pinVM = pinVM else {
            return 0.0
        }
        return calculateImageSize(imageSize: pinVM.pinModel.imageSize, newWidth: width)
    }
    func pinDetailLayoutNoteHeight(font: UIFont, width: CGFloat) -> CGFloat {
        guard let pinVM = pinVM else {
            return 0.0
        }
        return pinVM.heightForNote(font: font, width: width)
    }
}

extension AHPinContentLayoutHandler: UICollectionViewDelegate{
    
}

extension AHPinContentLayoutHandler: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AHPinContentCellIdentifier, for: indexPath) as! AHPinContentCell
        cell.pinVM = pinVM
        presentingCell = cell
        return cell
    }
}

// MARK:- Helper Methods
extension AHPinContentLayoutHandler {
    
    /// Return a proportional image height with a newWidth
    ///
    /// - parameter imageSize: original image size
    /// - parameter newWidth: the new width you want the image to fit in
    ///
    /// - returns: the new height for the image
    func calculateImageSize(imageSize: CGSize, newWidth: CGFloat) -> CGFloat {
        let newHeight = newWidth * imageSize.height / imageSize.width
        return newHeight
    }
}



