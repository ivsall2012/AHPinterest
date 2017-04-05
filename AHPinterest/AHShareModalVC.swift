//
//  AHShareModalVCViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/3/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHShareModalVC: UIViewController {
    var fingerRingView = UIImageView(image: #imageLiteral(resourceName: "finger-ring"))
    let minimumRingFollowDistance: CGFloat = 100.0
    var startingPoint: CGPoint? {
        didSet {
            if let startingPoint = startingPoint {
                print("startingPoint\(startingPoint)")
                fingerRingView.frame.origin = startingPoint
                fingerRingView.bounds.size = CGSize(width: 50, height: 50)
                self.view.addSubview(fingerRingView)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

///MARK:- Hooks for longPress
extension AHShareModalVC {
    func changed(point: CGPoint){
        guard let startingPoint = startingPoint else {
            return
        }
        print("moved point")
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
        dismiss(animated: true, completion: nil)
    }
    func calculateDistance(pointA: CGPoint, PointB: CGPoint) -> CGFloat {
        let xDist = pointA.x - PointB.x
        let yDist = pointA.y - PointB.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}













