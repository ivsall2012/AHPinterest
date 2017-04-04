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
    
    var modalVC: AHShareModalVC = AHShareModalVC()
    weak var mainVC: UIViewController?
    let animator: AHShareAnimator = AHShareAnimator()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // add long press gesture
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:))))
    }
    
    
    var photo: Photo? {
        didSet{
            self.contentView.backgroundColor = UIColor.orange
            self.contentView.layer.cornerRadius = 10
            self.contentView.layer.masksToBounds = true
            photoView.image = photo?.image
            captionLabel.text = photo?.caption
            comment.text = photo?.comment
        }
    }
    
    func longPressHandler(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            
            modalVC.transitioningDelegate = animator
            animator.fromView = self
            modalVC.modalPresentationStyle = .custom
            mainVC?.present(modalVC, animated: true, completion: nil)
        case .changed:
            let point = sender.location(in: modalVC.view)
            modalVC.changed(point: point)
        case .ended, .cancelled, .failed, .possible:
            let point = sender.location(in: modalVC.view)
            modalVC.ended(point: point)
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
                // either self.layer.masksToBounds = false or self.clipsToBounds = false will allow bgView goes out of bounds
                self.clipsToBounds = false
                
                let bgView = UIView(frame: self.bounds)
                bgView.layer.cornerRadius = 10
                bgView.backgroundColor = UIColor.lightGray
                bgView.alpha = 0.7
                self.insertSubview(bgView, belowSubview: self.contentView)
                self.contentView.layer.anchorPoint = .init(x: 0.5, y: 0.0)
                UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                        self.contentView.transform = .init(scaleX: 0.98, y: 0.98)
                        bgView.transform = .init(scaleX: 1.02, y: 1.02)
                        bgView.alpha = 0.4
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.5, animations: {
                        self.contentView.transform = .identity
                        bgView.transform = .identity
                        bgView.alpha = 0.0
                    })
                    
                    }, completion: { (_) in
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





















