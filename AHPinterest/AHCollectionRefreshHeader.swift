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
        self.addSubview(refreshControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetToInitial()
    }
    func resetToInitial() {
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - AHHeaderRefreshControlSize.height * 0.5
        refreshControl.frame = .init(x: 0, y: 0, width: AHHeaderRefreshControlSize.width, height: AHHeaderRefreshControlSize.height)
        refreshControl.center = .init(x: x, y: y)
        refreshControl.alpha = 0.3
        refreshControl.transform = .init(scaleX: 0.3, y: 0.3)
    }
    
    func resetToFinal() {
        let x = self.bounds.width * 0.5
        let y = self.bounds.height * 0.5
        refreshControl.center = .init(x: x, y: y)
        refreshControl.alpha = 1.0
        refreshControl.transform = .init(scaleX: 1.0, y: 1.0)
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
