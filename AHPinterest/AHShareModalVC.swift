//
//  AHShareModalVCViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/3/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

struct RightOnTop {
    var left:CGPoint = .zero
    var middle:CGPoint = .zero
    var right:CGPoint = .zero
    
    init(anchor: CGPoint, radius:CGFloat) {
        let a_cos_4_pi = radius * CGFloat(cos(M_PI_4))
        self.left = .init(x: anchor.x - a_cos_4_pi, y: anchor.y - a_cos_4_pi)
        self.middle = .init(x: anchor.x, y: anchor.y - radius)
        self.right = .init(x: anchor.x + a_cos_4_pi, y: anchor.y - a_cos_4_pi)
    }
}

class AHShareModalVC: UIViewController {
    let btnLeft = UIButton(type: .custom)
    let btnMiddle = UIButton(type: .custom)
    let btnRight = UIButton(type: .custom)
    var fingerRingView = UIImageView(image: #imageLiteral(resourceName: "finger-ring"))
    let minimumRingFollowDistance: CGFloat = 100.0
    let radius: CGFloat = 80.0
    let btnSize: CGSize = CGSize(width: 55, height: 55)
    let fingerRingSize:CGSize = CGSize(width: 60, height: 60)
    
    var rightOnTop: RightOnTop? = nil {
        didSet {
            if rightOnTop != nil {
                btnLeft.center = startingPoint!
                btnMiddle.center = startingPoint!
                btnRight.center = startingPoint!
                
                
            }
        }
    }
    var startingPoint: CGPoint? {
        didSet {
            if let startingPoint = startingPoint {
                rightOnTop = RightOnTop(anchor: startingPoint, radius: radius)
                fingerRingView.center = startingPoint
                fingerRingView.bounds.size = fingerRingSize
                self.view.addSubview(fingerRingView)
                self.view.layoutIfNeeded()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLeft.setImage(#imageLiteral(resourceName: "pin-btn"), for: .normal)
        btnLeft.bounds.size = btnSize
        btnMiddle.setImage(#imageLiteral(resourceName: "paper-plane"), for: .normal)
        btnMiddle.bounds.size = btnSize
        btnRight.setImage(#imageLiteral(resourceName: "more-btn"), for: .normal)
        btnRight.bounds.size = btnSize
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnLeft.alpha = 0.0
        btnMiddle.alpha = 0.0
        btnRight.alpha = 0.0
        self.view.addSubview(btnLeft)
        self.view.addSubview(btnMiddle)
        self.view.addSubview(btnRight)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// This function is called only by the transition animator
    func buttonAnimation() {
        if let rightOnTop = rightOnTop {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.btnLeft.center = rightOnTop.left
                self.btnMiddle.center = rightOnTop.middle
                self.btnRight.center = rightOnTop.right
                self.btnLeft.alpha = 1.0
                self.btnMiddle.alpha = 1.0
                self.btnRight.alpha = 1.0
                }, completion: nil)
        }
    }
}

///MARK:- Hooks for longPress
extension AHShareModalVC {
    func changed(point: CGPoint){
        guard let startingPoint = startingPoint else {
            return
        }
        let distanceToStarting = calculateDistance(pointA: point, PointB: startingPoint)
        if distanceToStarting > minimumRingFollowDistance {
            let ringToStarting = calculateDistance(pointA: fingerRingView.center, PointB: startingPoint)
            
            if ringToStarting > CGFloat(2.0) {
                // case 1, fingerRingView position was following the touch, but now it goes too far, it needs to go back to startingPoint
                ringGoesBack()
            }else{
                // case 2, current fingerRingView position is at(near) startingPoint, return
                return
            }
            
        }else{
            // the point is within the distance, follow the touch
            fingerRingView.center = point
        }
        
    }
    func ringGoesBack() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: { 
            self.fingerRingView.center = self.startingPoint!
            }, completion: nil)
    }
    func ended(point: CGPoint) {
        btnLeft.removeFromSuperview()
        btnMiddle.removeFromSuperview()
        btnRight.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    func calculateDistance(pointA: CGPoint, PointB: CGPoint) -> CGFloat {
        let xDist = pointA.x - PointB.x
        let yDist = pointA.y - PointB.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}


///MARK:- Helper Functions
extension AHShareModalVC {

}











