//
//  Cell.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class PinCell: UICollectionViewCell {
    
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteHeightConstraint: NSLayoutConstraint!
    weak var mainVC: UIViewController?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.orange
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
    
    var pinVM: PinViewModel? {
        didSet{
            if let pinVM = pinVM {
                let model = pinVM.pinModel
                self.note.text = model.note
                self.userName.text = model.userName
                self.userAvatar.AH_setImage(urlStr: model.avatarURL)
                self.imageView.AH_setImage(urlStr: model.imageURL)
                layoutIfNeeded()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userName.text = nil
        self.imageView.image = nil
        self.note.text = nil
        self.userAvatar.image = nil
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        return super.preferredLayoutAttributesFitting(layoutAttributes)
//    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attr = layoutAttributes as? AHLayoutAttributes{
            imageViewHeightConstraint.constant = attr.imageHeight
            noteHeightConstraint.constant = attr.noteHeight
            layoutIfNeeded()
        }
        
    }
}


extension PinCell {
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



















