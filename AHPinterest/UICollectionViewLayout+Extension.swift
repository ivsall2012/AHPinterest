//
//  UICollectionViewLayout+Extension.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/16/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

extension UICollectionViewLayout {
    func isIntercept(attr: UICollectionViewLayoutAttributes, rect: CGRect) -> Bool {
        return rect.intersects(attr.frame)
    }
}
