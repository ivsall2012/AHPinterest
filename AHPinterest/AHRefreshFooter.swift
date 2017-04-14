//
//  AHCollectionRefreshFooter.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/12/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHRefreshFooter: UICollectionReusableView {
    fileprivate var refreshControl: UIImageView = UIImageView(image: #imageLiteral(resourceName: "refresh-control"))
    var isSpinning: Bool = false
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
        refreshControl.bounds.size = AHRefreshFooterSize
        let x: CGFloat = self.bounds.width * 0.5
        let y: CGFloat = 0.0
        refreshControl.layer.anchorPoint = .init(x: 0.5, y: 0.5)
        refreshControl.center = .init(x: x, y: y)
        refreshControl.alpha = 1.0
        refreshControl.layer.removeAllAnimations()
    }
    func refresh() {
        if !isSpinning{
            isSpinning = true
            isHidden = false
            let x = self.bounds.width * 0.5
            let y = AHRefreshFooterSize.height * 0.5
            refreshControl.transform = .identity
            refreshControl.center = .init(x: x, y: y)
            
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
    
    func endRefersh() {
        // an ending animation would work here becuase the footer refreshControl is always stick to the bottom of the scrollView and when new data coming in the contentSize changes in which makes refreshControl change to stick to the bottom again
        isSpinning = false
    }
    
    override func prepareForReuse() {
        reset()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
    }
    
    
    //    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    //        print("preferredLayoutAttributesFitting :\(layoutAttributes)")
    //        return super.preferredLayoutAttributesFitting(layoutAttributes)
    //    }
}
