//
//  AHShareModalVCViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/3/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

fileprivate let minimumRingFollowDistance: CGFloat = 100.0

fileprivate let radius: CGFloat = 80.0

fileprivate let btnSize: CGSize = CGSize(width: 55, height: 55)

fileprivate let fingerRingSize:CGSize = CGSize(width: 60, height: 60)

/// triggerDistance will be used agaist the distance between the touch point to btn.center used in buttonSelectionAnimation and maybe buttonPushAnimation
fileprivate let triggerDistance = radius * 0.7


class AHShareModalVC: UIViewController {
    let btnLeft = UIButton(type: .custom)
    let btnMiddle = UIButton(type: .custom)
    let btnRight = UIButton(type: .custom)
    var fingerRingView = UIImageView(image: #imageLiteral(resourceName: "finger-ring"))
    var allButtons: [UIButton]?
    
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
        // transition animator will handler removing all subviews when dismissing
        setupButtons()
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
    
    
}

// MARK: Setup Functions
extension AHShareModalVC {
    func setupButtons() {
        btnLeft.setImage(#imageLiteral(resourceName: "pin-btn-normal"), for: .normal)
        btnLeft.setImage(#imageLiteral(resourceName: "pin-btn-selected"), for: .selected)
        btnLeft.bounds.size = btnSize
        btnLeft.addTarget(self, action: #selector(pinBtnTapped(_:)), for: .touchUpInside)
        btnMiddle.setImage(#imageLiteral(resourceName: "paper-plane-normal"), for: .normal)
        btnMiddle.setImage(#imageLiteral(resourceName: "paper-plane-selected"), for: .selected)
        btnMiddle.bounds.size = btnSize
        btnMiddle.addTarget(self, action: #selector(papaerPlaneTapped(_:)), for: .touchUpInside)
        btnRight.setImage(#imageLiteral(resourceName: "more-btn-normal"), for: .normal)
        btnRight.setImage(#imageLiteral(resourceName: "more-btn-selected"), for: .selected)
        btnRight.bounds.size = btnSize
        btnRight.addTarget(self, action: #selector(moreBtnPlaneTapped(_:)), for: .touchUpInside)
        
        allButtons = [btnLeft,btnMiddle,btnRight]
    }
}


// MARK: Handler Events
extension AHShareModalVC {
    func pinBtnTapped(_ sender: UIButton){
        print("pinBtnTapped")
        dismiss(animated: true, completion: nil)
    }
    func papaerPlaneTapped(_ sender: UIButton){
        print("papaerPlaneTapped")
        dismiss(animated: true, completion: nil)
    }
    func moreBtnPlaneTapped(_ sender: UIButton){
        print("moreBtnPlaneTapped")
        dismiss(animated: true, completion: nil)
    }

}

// MARK: Hooks Called by Outside Object
extension AHShareModalVC {
    func changed(point: CGPoint){
        guard let startingPoint = startingPoint else {
            return
        }
        fingerRingAnimation(point, startingPoint)
        buttonsAnimation(point)
        
    }
    
    
    func ended(point: CGPoint) {
        guard let allButtons = allButtons else {
            return
        }
        var targetBtn: UIButton? = nil
        for btn in allButtons {
            if btn.isSelected {
                targetBtn = btn
                btn.sendActions(for: .touchUpInside)
            }
        }
        if targetBtn == nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
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


// MARK:- Animations
extension AHShareModalVC: AHAnimatorDelegate {
    func AHAnimatorDidFinishPresentingTransition() {
        buttonAnimation()
    }
    
    func buttonsAnimation(_ point: CGPoint) {
        guard let allButtons = allButtons else {
            return
        }
        
        if let targetBtn = buttonSelectionAnimations(point, allButtons) {
            buttonPushAnimation(point, targetBtn)
        }
        
        
    }
    /// return if there's a(only) btn selected
    func buttonSelectionAnimations(_ point: CGPoint,_ allButtons: [UIButton]) -> UIButton? {
        var min: CGFloat = CGFloat(FLT_MAX)
        var targetBtn: UIButton? = nil
        for btn in allButtons {
            // from touch point to btn, find min(closest one)
            let delta = calculateDistance(pointA: point, PointB: btn.center)
            if delta < min && delta <= triggerDistance {
                min = delta
                targetBtn = btn
            }
            UIView.animate(withDuration: 0.2, animations: { 
                btn.isSelected = false
                btn.transform = .identity
            })
            
        }
        
        if targetBtn != nil {
            targetBtn!.isSelected = true
        }
        return targetBtn
    }
    
    /// Animate when touch approaches the button
    func buttonPushAnimation(_ point: CGPoint, _ targetBtn: UIButton) {
        guard let startingPoint = startingPoint else {
            return
        }
        // this distance will be not be greater than trigerDistance since selectionAnimation already filtered out touch points based on triggerDistance which is also the touch point to btn.center, like below.
        let distance = calculateDistance(pointA: point, PointB: targetBtn.center)
        let ratio = distance / triggerDistance
        
        
        let enlargeScale = ratio * 0.2
        // enlargeScale will be [1.0, 1.2]
        let scaleTransform = CGAffineTransform(scaleX: 1 + enlargeScale, y: 1 + enlargeScale)

        
        // movement will be [1, 1.2] * radius, from starting point
        let maxMovement = radius * 0.1
        let movement = ratio * maxMovement
        // btn alway moves along from: startingPoint, to: point
        let unitVector = findUnitVector(from: startingPoint, to: point)
        let newPoint = newPosition(forMovement: movement, withUnitVector: unitVector)
        let movementTransform = CGAffineTransform(translationX: newPoint.x, y: newPoint.y)
        let newTransform: CGAffineTransform = movementTransform.concatenating(scaleTransform)
        UIView.animate(withDuration: 0.2, animations: {
            targetBtn.transform = newTransform
            }, completion: nil)
    }
    
    /// Animate when the touch approach to the press ring
    func fingerRingAnimation(_ point: CGPoint, _ startingPoint: CGPoint) {
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
    
    func calculateDistance(pointA: CGPoint, PointB: CGPoint) -> CGFloat {
        let xDist = pointA.x - PointB.x
        let yDist = pointA.y - PointB.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func findUnitVector(from pointA: CGPoint, to pointB: CGPoint) -> CGPoint{
        // 1. construct vector AB
        let vector = CGPoint(x: pointB.x - pointA.x, y: pointB.y - pointA.y)
        
        // 2. find magnitude of AB
        let magnitude = CGFloat(sqrt((vector.x * vector.x) + (vector.y * vector.y)))
        
        // 3. calculate unit vector for AB
        let unitVectorX = vector.x / magnitude
        let unitVectorY = vector.y / magnitude
        
        return CGPoint(x: unitVectorX, y: unitVectorY)
        
    }
    
    func newPosition(forMovement distance: CGFloat, withUnitVector point: CGPoint) -> CGPoint {
        return CGPoint(x: distance * point.x, y: distance * point.y)
    }
}



// MARK:- Convenient Struct
struct ButtonsPositions {
    var left:CGPoint = .zero
    var middle:CGPoint = .zero
    var right:CGPoint = .zero
    var anchor: CGPoint = .zero
    var radius: CGFloat = 0.0
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

// MARK:  Calculations For Buttons
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






