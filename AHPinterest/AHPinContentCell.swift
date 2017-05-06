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
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                highLightAnimation()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.shouldRasterize = true
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userName.text = nil
        pinImageView.image = nil
        noteLabel.text = nil
        userAvatar.image = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
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


extension AHPinContentCell {
    func highLightAnimation() {
        self.clipsToBounds = false
        let bgView = UIView(frame: self.bounds)
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor.lightGray
        bgView.alpha = 0.7
        self.insertSubview(bgView, belowSubview: contentView)
        self.contentView.layer.anchorPoint = .init(x: 0.5, y: 0.0)
        
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.contentView.transform = .init(scaleX: 0.98, y: 0.98)
            bgView.transform = .init(scaleX: 1.02, y: 1.02)
            bgView.alpha = 0.4
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.35, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: [], animations: {
            self.contentView.transform = .identity
            bgView.transform = .identity
            bgView.alpha = 0.0
            }, completion: { (_) in
                self.clipsToBounds = true
                bgView.removeFromSuperview()
        })
    }
}

