//
//  PinCardViewModel.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/8/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinViewModel: NSObject {
    var pinModel: AHPinDataModel
    fileprivate var noteHeight:CGFloat?
    init(pinModel: AHPinDataModel) {
        self.pinModel = pinModel
    }
}


// MARK:- Calculations
extension AHPinViewModel {
    func heightForNote(font: UIFont, width: CGFloat) -> CGFloat{
        if noteHeight == nil {
            let note = pinModel.note
            let size = CGSize(width: width - 2 * AHCellPadding, height: CGFloat(Double.greatestFiniteMagnitude))
            let rect =  (note as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            noteHeight = ceil(rect.height)
            return noteHeight!
        }else{
            return noteHeight!
        }
    }
}
