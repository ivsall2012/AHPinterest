//
//  AHRefershUI.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/11/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHRefershUI: NSObject {
    fileprivate static var isSetup = false
    fileprivate static let screenSize: CGSize = UIScreen.main.bounds.size
    fileprivate static var refreshControl: UIImageView = UIImageView(image: #imageLiteral(resourceName: "refresh-control"))
    
    fileprivate class func setup() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(refreshControl)
        refreshControl.frame.size = .init(width: 50, height: 50)
        refreshControl.center = window.center
    }
    
    class func show() {
        if !isSetup {
            setup()
        }
        refreshControl.isHidden = false
        startAnimateRefresh()
    }
    
    fileprivate class func startAnimateRefresh() {
        // need to do animation and networking
        let rotaton = CABasicAnimation(keyPath: "transform.rotation.z")
        rotaton.fromValue = 0.0
        rotaton.toValue = 2 * CGFloat(M_PI)
        rotaton.duration = 1.0;
        rotaton.repeatCount = FLT_MAX;
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.3
        scale.toValue = 1.0
        scale.duration = 0.5;
        
        refreshControl.layer.add(scale, forKey: "scale")
        refreshControl.layer.add(rotaton, forKey: "ratate")
        
        
    }
    
    fileprivate class func stopAnimateRefresh() {
        refreshControl.layer.removeAllAnimations()
        
        let rotaton = CABasicAnimation(keyPath: "transform.rotation.z")
        rotaton.fromValue = 0.0
        rotaton.toValue = 2 * CGFloat(M_PI)
        rotaton.duration = 1.0;
        rotaton.repeatCount = FLT_MAX;
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 0.0
        scale.duration = 0.35;
        
        refreshControl.layer.add(scale, forKey: "scale")
        refreshControl.layer.add(rotaton, forKey: "ratate")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35 ) {
            refreshControl.layer.removeAllAnimations()
            refreshControl.isHidden = true
        }
        
    }

    class func dismiss() {
        stopAnimateRefresh()
    }
}
