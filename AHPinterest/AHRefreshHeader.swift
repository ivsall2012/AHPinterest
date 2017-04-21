//
//  AHCollectionRefreshHeader.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/9/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHRefreshHeader: UICollectionReusableView {
    fileprivate var refreshControl: UIImageView = UIImageView(image: #imageLiteral(resourceName: "refresh-control"))
    var isSpinning: Bool = false
    var ratio: CGFloat = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.addSubview(refreshControl)
        reset()
    }
    
    fileprivate func reset() {
        refreshControl.bounds.size = AHRefreshHeaderSize
        let x = self.bounds.width * 0.5
        let y: CGFloat = AHHeaderHeight * 0.5
        refreshControl.layer.anchorPoint = .init(x: 0.5, y: 0.5)
        refreshControl.center = .init(x: x, y: y)
        refreshControl.alpha = 0.3
        refreshControl.transform = .init(scaleX: 0.3, y: 0.3)
    }
    func refresh() {
        if !isSpinning{
            isSpinning = true
            refreshControl.alpha = 1.0
            refreshControl.transform = .identity
            
            // need to do animation and networking
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0.0
            animation.toValue = 2 * CGFloat(M_PI)
            animation.duration = 1.0;
            animation.repeatCount = FLT_MAX;
            refreshControl.layer.add(animation, forKey: "refreshSpinning")
            return
        }
    }
    func pulling(ratio: CGFloat) {
        guard ratio <= 1.0 else {
            return
        }
        self.ratio = ratio
        // using adjustedRatio because alpha and transformScale are initially 0.3
        let adjustedRatio = ratio + 0.3
        
        // using ratio because moving from bottom to centerY needs the ratio from 0.0 to 1.0
        let delta = ratio
        // an extra angle to make the end angle in transform, exactly faced-up
        let angleOffset = CGFloat(M_PI_4) * 0.1
        refreshControl.alpha = adjustedRatio
        let transformScale = CGAffineTransform(scaleX: adjustedRatio, y: adjustedRatio)
        let transformCenter = CGAffineTransform(translationX: 0.0, y: -delta)
        let transformAngle = CGAffineTransform(rotationAngle: 2 * CGFloat(M_PI) * ratio + angleOffset)
        
        // transformAngle has to come first!!
        refreshControl.transform = transformAngle.concatenating(transformCenter).concatenating(transformScale)
    }
    func endRefersh() {
        ratio = 0.0
        isSpinning = false
        reset()
        refreshControl.layer.removeAnimation(forKey: "refreshSpinning")
    }
    
    override func prepareForReuse() {
        endRefersh()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {

    }
    
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        print("preferredLayoutAttributesFitting :\(layoutAttributes)")
//        return super.preferredLayoutAttributesFitting(layoutAttributes)
//    }
}
