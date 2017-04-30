//
//  AHPhotoBrowserCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


class AHDetailCell: UICollectionViewCell {
    
    weak var pageVC: AHPinVC? {
        didSet {
            if let pinContentVC = pageVC {
                contentView.subviews.forEach({ (view) in
                    view.removeFromSuperview()
                })
                
                pinContentVC.view.willMove(toSuperview: self)
                contentView.addSubview(pinContentVC.view)
                pinContentVC.view.didMoveToSuperview()
                
            }
        }
    }

    override func awakeFromNib() {
        self.backgroundColor = UIColor.blue
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pageVC?.view.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pageVC?.view.frame = self.bounds
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
    }
    
}

