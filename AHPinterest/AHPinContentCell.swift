//
//  AHPinContentCell.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/18/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinContentCell: UICollectionViewCell {
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteHeight: NSLayoutConstraint!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var pinImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    weak var pinVM: AHPinViewModel? {
        didSet {
            if let pinVM = pinVM {
                noteLabel.text = pinVM.pinModel.note
                userName.text = pinVM.pinModel.userName
                
                pinImageView.AH_setImage(urlStr: pinVM.pinModel.imageURL, completion: { (image) in
                    // image could be nil though due to network problem
                    
                    // check if the cell is still the cell requested the image
                    if pinVM == self.pinVM {
                        self.pinImageView.image = image
                    }
                })
                
                userAvatar.AH_setImage(urlStr: pinVM.pinModel.avatarURL, completion: { (image) in
                    if pinVM == self.pinVM {
                        self.userAvatar.image = image
                    }
                })
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userName.text = nil
        pinImageView.image = nil
        noteLabel.text = nil
        userAvatar.image = nil
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attr = layoutAttributes as? AHPinLayoutAttributes {
            pinImageViewHeight.constant = attr.imageHeight
            noteHeight.constant = attr.noteHeight
            layoutIfNeeded()
        }
    }
}
