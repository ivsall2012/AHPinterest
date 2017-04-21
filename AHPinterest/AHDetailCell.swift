//
//  AHPhotoBrowserCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


class AHDetailCell: UICollectionViewCell {
    
    weak var pinContentVC: AHPinContentVC? {
        didSet {
            if let pinContentVC = pinContentVC {
                contentView.subviews.forEach({ (view) in
                    view.removeFromSuperview()
                })
                
                pinContentVC.view.willMove(toSuperview: self)
                contentView.addSubview(pinContentVC.view)
                pinContentVC.view.didMoveToSuperview()
                
            }
        }
    }
    weak var pinVM: AHPinViewModel?

    override func awakeFromNib() {
        self.backgroundColor = UIColor.blue
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pinContentVC?.view.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pinContentVC?.view.frame = self.bounds
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
    }
    
}

