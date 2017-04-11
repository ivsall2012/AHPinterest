//
//  AHCollectionRefreshHeader.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/9/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHCollectionRefreshHeader: UICollectionReusableView {
    fileprivate var refreshControl: UIImageView = UIImageView(image: #imageLiteral(resourceName: "refresh-control"))
    fileprivate var isSpinning: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        refreshControl.bounds.size = AHHeaderRefreshControlSize
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - AHHeaderRefreshControlSize.height * 0.5
        self.layer.anchorPoint = .init(x: 0.5, y: 0.5)
        refreshControl.layer.anchorPoint = .init(x: 0.5, y: 0.5)
        refreshControl.center = .init(x: x, y: y)
        refreshControl.alpha = 0.3
        refreshControl.transform = .init(scaleX: 0.3, y: 0.3)
        self.addSubview(refreshControl)
    }
    
    func transformRefreshControl(absOffset: CGFloat) {
        guard absOffset >= 0.0 else {
            return
        }
        guard !isSpinning else {
            return
        }
        let ratio = absOffset / self.bounds.height * 0.5
        if ratio >= 1.0 {
            // should do aniamtion and notify to make network call
            return
        }else{
            if !isSpinning && ratio >= 0.7 {
                isSpinning = true
                print("ratio:\(ratio)")
                // need to do animation and networking
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.fromValue = 0.0
                animation.toValue = 2 * CGFloat(M_PI)
                animation.duration = 1.0;
                animation.repeatCount = FLT_MAX;
                refreshControl.layer.add(animation, forKey: "refreshSpinning")
                return
            }
            
            // using adjustedRatio because alpha and transformScale are initially 0.3
            let adjustedRatio = ratio + 0.3
            
            // using ratio because moving from bottom to centerY needs the ratio from 0.0 to 1.0
            let delta = ratio * self.bounds.height * 0.5
            // an extra angle to make the end angle in transform, exactly faced-up
            let angleOffset = CGFloat(M_PI_4) * 0.1
            refreshControl.alpha = adjustedRatio
            let transformScale = CGAffineTransform(scaleX: adjustedRatio, y: adjustedRatio)
            let transformCenter = CGAffineTransform(translationX: 0.0, y: -delta)
            let transformAngle = CGAffineTransform(rotationAngle: 2 * CGFloat(M_PI) * ratio + angleOffset)
            
            // transformAngle has to come first!!
            refreshControl.transform = transformAngle.concatenating(transformCenter).concatenating(transformScale)
            
        }
    }
    
    func endRefersh() {
        isSpinning = false
        refreshControl.layer.removeAnimation(forKey: "refreshSpinning")
    }
    
    override func prepareForReuse() {
        print("header prepareForReuse")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        print("header received attr")
    }
    
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        print("preferredLayoutAttributesFitting :\(layoutAttributes)")
//        return super.preferredLayoutAttributesFitting(layoutAttributes)
//    }
}
