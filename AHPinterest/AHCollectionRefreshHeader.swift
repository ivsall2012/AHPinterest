//
//  AHCollectionRefreshHeader.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/9/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHCollectionRefreshHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        print("header prepareForReuse")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        print("header received attr")
    }
    
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        print("preferredLayoutAttributesFitting :\(layoutAttributes)")
//        return super.preferredLayoutAttributesFitting(layoutAttributes)
//    }
}
