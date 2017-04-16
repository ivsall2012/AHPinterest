//
//  NSIndexPath+Extension.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/16/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import Foundation

extension NSIndexPath{
    open override var description: String {
        return "indexPath{section: \(self.section), item: \(self.item)}"
    }
}
