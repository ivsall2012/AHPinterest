//
//  AHPhotoBrowserCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


class AHPageCell: UICollectionViewCell {
    
    weak var pageVC: UIViewController? {
        didSet {
            if let pageVC = pageVC {
                contentView.subviews.forEach({ (view) in
                    view.removeFromSuperview()
                })
                
                pageVC.view.willMove(toSuperview: contentView)
                contentView.addSubview(pageVC.view)
                pageVC.view.didMoveToSuperview()
                
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

