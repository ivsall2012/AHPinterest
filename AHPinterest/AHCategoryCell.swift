//
//  AHCategoryCell.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/29/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHCategoryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var trending: UILabel!

    var dataModel: AHCategoryDataModel? {
        didSet {
            if let dataModel = dataModel {
                trending.isHidden = dataModel.isTrending
                categoryName.text = dataModel.categoryName
                imageView.AH_setImage(urlStr: dataModel.coverURL, completion: {[weak self] (image) in
                    // cell being resued already, return. Image is already in cache.
                    if self?.dataModel !== dataModel {
                        return
                    }
                    if image != nil {
                        self?.imageView.image = image
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 10
    }
}
