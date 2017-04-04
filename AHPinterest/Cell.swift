//
//  Cell.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var photoViewHeightConstraint: NSLayoutConstraint!
    
    
    var photo: Photo? {
        didSet{
            self.contentView.backgroundColor = UIColor.orange
            self.contentView.layer.cornerRadius = 10
            self.contentView.layer.masksToBounds = true
//            self.layer.masksToBounds = false
            photoView.image = photo?.image
            captionLabel.text = photo?.caption
            comment.text = photo?.comment
        }
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        return super.preferredLayoutAttributesFitting(layoutAttributes)
//    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attr = layoutAttributes as? AHLayoutAttributes{
            photoViewHeightConstraint.constant = attr.photoHeight
        }
        
    }
}

extension Cell{
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.clipsToBounds = false
                
                let bgView = UIView(frame: self.bounds)
                bgView.layer.cornerRadius = 10
                bgView.backgroundColor = UIColor.lightGray
                self.insertSubview(bgView, belowSubview: self.contentView)
                UIView.animateKeyframes(withDuration: 0.65, delay: 0.0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                        self.contentView.transform = .init(scaleX: 0.98, y: 0.98)
                        bgView.transform = .init(scaleX: 1.02, y: 1.02)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.15, animations: {
                        self.contentView.transform = .identity
                        bgView.transform = .identity
                    })
                    
                    }, completion: { (_) in
                        print("completion")
                        self.clipsToBounds = true
                        bgView.removeFromSuperview()
                })
            }else{
                
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            print("isSelected:\(isSelected)")
        }
    }
}





















