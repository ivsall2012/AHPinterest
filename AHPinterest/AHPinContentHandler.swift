//
//  AHPinContentHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinContentHandler: NSObject {

}

extension AHPinContentHandler: AHPinContentDelegate {
    func AHPinContentSize(index: IndexPath) -> CGSize {
        return CGSize(width: 0.0, height: 200.0)
    }
}
