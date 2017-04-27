//
//  AHPopTransitionVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/25/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPopInteractiveVC: UIViewController {
    var previousPoint: CGPoint?
    var subjectBg: UIView? {
        didSet {
            if let subjectBg = subjectBg {
                subjectBgOriginalFrame = subjectBg.frame
            }
        }
    }
    var subject: UIView? {
        didSet {
            if let subject = subject {
                subjectOriginalFrame = subject.frame
            }
        }
    }
    
    var subjectOriginalFrame = CGRect.zero
    var subjectBgOriginalFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let bgSnap = subjectBg{
            self.view.addSubview(bgSnap)
        }
        
        if let subject = subject {
            self.view.addSubview(subject)
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subjectBg?.removeFromSuperview()
        subject?.removeFromSuperview()
        previousPoint = nil
    }
    
    func touchMoved(to point:CGPoint) {
        guard let subjectBg = subjectBg, let subject = subject else {
            return
        }
        
        if previousPoint == nil {
            previousPoint = point
        }
        // do not use gesture's translation for delta offset here, it has performance problem
        let dx = point.x - previousPoint!.x
        let dy = point.y - previousPoint!.y
        previousPoint = point
        
        let total = self.view.bounds.size.height - subjectBgOriginalFrame.origin.y
        
        // ratio indicates subjectbg's size relative to original's
        let ratio = 1 - (subjectBg.frame.origin.y / total)
        
        
        handleSubjectBg(subjectBg,dx, dy, ratio)
        handlerSubject(subject, dx, dy, ratio)
        

        
    }
}

extension AHPopInteractiveVC {
    func handleSubjectBg(_ subjectBg: UIView, _ dx: CGFloat, _ dy: CGFloat, _ ratio: CGFloat) {
        guard let subject = subject else { return }
        
        let newX = subjectBg.frame.origin.x + dx
        var newY = subjectBg.frame.origin.y + dy
        
        if newY < 0.0 {
            newY = subjectBg.frame.origin.y
        }
        
        // won't move Y position untill subject is being pulled down past to subjectOriginalFrame.origin.y
        if subject.frame.origin.y < subjectOriginalFrame.origin.y {
            newY = subjectBg.frame.origin.y
            subjectBg.frame.origin.x = newX
            subjectBg.frame.origin.y = newY
        }else{
            let scale = CGAffineTransform(scaleX: ratio, y: ratio)

            subjectBg.transform = scale
            subjectBg.frame.origin.x = newX - dx * (1 - ratio)
            subjectBg.frame.origin.y = newY - dy * (1 - ratio)
        }
        
        
    }
    func handlerSubject(_ subject: UIView, _ dx: CGFloat, _ dy: CGFloat, _ ratio: CGFloat) {
        
        
        if subject.frame.origin.y < subjectOriginalFrame.origin.y {
            let newX = subject.frame.origin.x + dx
            let newY = subject.frame.origin.y + dy
            subject.frame.origin.x = newX
            subject.frame.origin.y = newY
        }else{
            
            
            let newX = subject.frame.origin.x + dx * ratio
            let newY = subject.frame.origin.y + dy * ratio
            
            let scale = CGAffineTransform(scaleX: ratio, y: ratio)
            
            subject.transform = scale
            subject.frame.origin.x = newX
            subject.frame.origin.y = newY
        }
        
    }
}




