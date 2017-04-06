//
//  AHShareModalVCViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/3/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

//enum WhichSide {
//    case leftSide
//    case rightSide
//    init(point: CGPoint, rect: CGRect) {
//        if isLeft(point: point, rect: rect){
//            self = .leftSide
//        }else{
//            self = .rightSide
//        }
//    }
//    /// Return true if it's near to the left side of the view, false is for right side
//    func isLeft(point: CGPoint, rect: CGRect) -> Bool {
//        let size = rect.size
//        if abs(point.x) < abs(size.width - point.x) {
//            return true
//        }else{
//            return false
//        }
//    }
//}

fileprivate let minimumRingFollowDistance: CGFloat = 100.0
fileprivate let radius: CGFloat = 80.0
fileprivate let btnSize: CGSize = CGSize(width: 55, height: 55)
fileprivate let fingerRingSize:CGSize = CGSize(width: 60, height: 60)



struct ButtonsPositions {
    var left:CGPoint = .zero
    var middle:CGPoint = .zero
    var right:CGPoint = .zero
    var anchor: CGPoint = .zero
    var radius: CGFloat = 0.0
//    var whichSide: WhichSide?
//    var restraint:CGRect = .zero
    init(anchor: CGPoint, radius:CGFloat) {
        self.anchor = anchor
        self.radius = radius
    }
    
    /// This function devides the total width of the scree into 7 columns
    //    0 1 2 3 4 5 6
    //  | - - - - - - - |
    //  | - - - - - - - |
    //  | - - - - - - - |
    //  | - - - - - - - |
    // column 2,3,4 use zero_pi_Up
    // column 1,5 use pi_radian_up_left. If it's 1, flip points based on anchor.y
    // column 0,6 use pi_4_up_left. If it's 0, flip points based on anchor.y
    mutating func decide() {
        // We first calculate 3,4,5,6,7 since all the functions above are based on scenarios on the right side, faced-up of the screen.
        let unit = UIScreen.main.bounds.width / 7.0
        if anchor.x >= 2 * unit && anchor.x <= 5 * unit {
            zero_pi_up()
        }
        else if (anchor.x <= 6 * unit && anchor.x > 5 * unit) ||
                (anchor.x < 2 * unit && anchor.x >= 1 * unit){
            pi_radian_up_left()
        }
        else if (anchor.x < 7 * unit && anchor.x > 6 * unit) ||
            (anchor.x < 1 * unit && anchor.x > 0.0 * unit){
            pi_4_up_left()
        }
        
        // We flip points if anchor is on the left side of the screen.
        if anchor.x < 2 * unit {
            self.left = flipBasedOnY(for: self.left, basedOn: self.anchor)
            self.right = flipBasedOnY(for: self.right, basedOn: self.anchor)
            self.middle = flipBasedOnY(for: self.middle, basedOn: self.anchor)
            
            // switch the left and right positions according to Pinterest, which is good design for right-handed people -- making more-btn less useful ??
            let temp = self.left
            self.left = self.right
            self.right = temp
        }
        
        if anchor.y - radius - btnSize.height < 0 {
            // this means the 3 buttons are too close to top edge screen
            // flip baed on anchor.x
            self.left = flipBasedOnX(for: self.left, basedOn: self.anchor)
            self.right = flipBasedOnX(for: self.right, basedOn: self.anchor)
            self.middle = flipBasedOnX(for: self.middle, basedOn: self.anchor)
        }
        
        
    }

    
    func flipBasedOnX(for point: CGPoint, basedOn anchor: CGPoint) -> CGPoint {
        let x = point.x
        let y = anchor.y + (anchor.y - point.y)
        return CGPoint(x: x, y: y)
    }
    func flipBasedOnY(for point: CGPoint, basedOn anchor: CGPoint) -> CGPoint {
        let y = point.y
        let x = anchor.x + (anchor.x - point.x)
        return CGPoint(x: x, y: y)
    }

}

///MARK:- Helper functions for positioning the coordinates of the buttons
extension ButtonsPositions {
    /// middle btn pointing zero(0) radian relative to anchor.y, o is button, 0 is anchor
    //    o
    //  o   o
    //    0
    mutating func zero_pi_up(){
        let radius = self.radius
        let anchor = self.anchor
        
        let r_cos_pi_4 = radius * CGFloat(cos(M_PI_4))
        let left = CGPoint(x: anchor.x - r_cos_pi_4, y: anchor.y - r_cos_pi_4)
        let middle = CGPoint(x: anchor.x, y: anchor.y - radius)
        let right = CGPoint(x: anchor.x + r_cos_pi_4, y: anchor.y - r_cos_pi_4)
        
        self.left = left
        self.right = right
        self.middle = middle
        
    }
    /// middle btn pointing pi/6(30) radian faced-up relative to anchor.y, o is button, 0 is anchor. The radian here is up to you
    //   o  o
    // o
    //    0
    mutating func pi_radian_up_left(){
        let radius = self.radius
        let anchor = self.anchor
        
        let radian = M_PI / 8
        let r_sin_radian = radius * CGFloat(sin(radian))
        let r_cos_radian = radius * CGFloat(cos(radian))
        let r_sin_3_radian = radius * CGFloat(sin(3 * radian))
        let r_cos_3_radian = radius * CGFloat(cos(3 * radian))
        
        let left = CGPoint(x: anchor.x - r_sin_3_radian, y: anchor.y - r_cos_3_radian)
        let middle = CGPoint(x: anchor.x - r_sin_radian, y: anchor.y - r_cos_radian)
        let right = CGPoint(x: anchor.x + r_sin_radian, y: anchor.y - r_cos_radian)
        
        self.left = left
        self.right = right
        self.middle = middle
        
    }
    /// middle btn pointing pi/4(45) radian faced-up relative to anchor.y, o is button, 0 is anchor
    //     o
    //   o
    //  o   0
    mutating func pi_4_up_left(){
        let radius = self.radius
        // move achor.x to the left a bit to avoid the right most btn intercept with left edge of screen
        let anchor = CGPoint(x: self.anchor.x - 10, y: self.anchor.y)
        
        
        let r_cos_pi_4 = radius * CGFloat(cos(M_PI_4))
        let left = CGPoint(x: anchor.x - radius, y: anchor.y)
        let middle = CGPoint(x: anchor.x - r_cos_pi_4, y: anchor.y - r_cos_pi_4)
        let right = CGPoint(x: anchor.x, y: anchor.y - radius)
        
        self.left = left
        self.right = right
        self.middle = middle
        
    }
}



class AHShareModalVC: UIViewController {
    let btnLeft = UIButton(type: .custom)
    let btnMiddle = UIButton(type: .custom)
    let btnRight = UIButton(type: .custom)
    var fingerRingView = UIImageView(image: #imageLiteral(resourceName: "finger-ring"))
    
    
    var buttonsPositions: ButtonsPositions? = nil {
        didSet {
            if buttonsPositions != nil {
                btnLeft.center = startingPoint!
                btnMiddle.center = startingPoint!
                btnRight.center = startingPoint!
                
                
            }
        }
    }
    var startingPoint: CGPoint? {
        didSet {
            if let startingPoint = startingPoint {
                buttonsPositions = ButtonsPositions(anchor: startingPoint, radius: radius)
                buttonsPositions?.decide()
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
        if let buttonsPositions = buttonsPositions {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.btnLeft.center = buttonsPositions.left
                self.btnMiddle.center = buttonsPositions.middle
                self.btnRight.center = buttonsPositions.right
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











