//
//  AHPhotoBrowserCell.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


class AHDetailCell: UICollectionViewCell {
    
    weak var pinVC: AHPinVC?
    weak var pinVM: AHPinViewModel?

    override func awakeFromNib() {
        self.backgroundColor = UIColor.blue
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

