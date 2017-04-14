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
    var imageView = UIImageView()

    override func awakeFromNib() {

    }
    
    func tapHanlder(_ sender: UITapGestureRecognizer){
        if let pinVC = pinVC {
            pinVC.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

