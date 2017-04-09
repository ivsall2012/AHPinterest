//
//  PinCardViewModel.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/8/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class PinViewModel: NSObject {
    var pinModel: PinDataModel
    
    init(pinModel: PinDataModel) {
        self.pinModel = pinModel
    }
}


// MARK:- Calculations
extension PinViewModel {
    func heightForNote(font: UIFont, width: CGFloat) -> CGFloat{
        let note = pinModel.note
        let size = CGSize(width: width - 2 * cellPadding, height: CGFloat(DBL_MAX))
        let rect =  (note as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
