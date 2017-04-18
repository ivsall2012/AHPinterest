//
//  AHPhotoBrowserCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


class AHDetailCell: UICollectionViewCell {
    
    weak var pinVC: AHPinVC? {
        didSet {
            if let pinVC = pinVC {
                contentView.subviews.forEach({ (view) in
                    view.removeFromSuperview()
                })
                pinVC.view.willMove(toSuperview: self)
                contentView.addSubview(pinVC.view)
                pinVC.view.didMoveToSuperview()
                
            }
        }
    }
    weak var pinVM: AHPinViewModel?

    override func awakeFromNib() {
        self.backgroundColor = UIColor.blue
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pinVC?.view.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pinVC?.view.frame = self.bounds
    }
    
}

