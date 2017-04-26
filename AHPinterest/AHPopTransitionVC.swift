//
//  AHPopTransitionVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/25/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPopTransitionVC: UIViewController {
    var previousPoint: CGPoint?
    var subjectBg: UIView?
    var subject: UIView? {
        didSet {
            if let subject = subject {
                subjectOriginalFrame = subject.frame
            }
        }
    }
    var subjectOriginalFrame = CGRect.zero
    
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
        
        handleSubjectBg(subjectBg,dx, dy)
        handlerSubject(subject, dx, dy)
        

        
    }
}

extension AHPopTransitionVC {
    func handleSubjectBg(_ subjectBg: UIView, _ dx: CGFloat, _ dy: CGFloat) {
        guard let subject = subject else { return }
        
        let newX = subjectBg.frame.origin.x + dx
        var newY = subjectBg.frame.origin.y + dy
        
        if newY < 0.0 {
            newY = subjectBg.frame.origin.y
        }
        
        // won't Y position untill subject is being pulled down past to subjectOriginalFrame.origin.y
        if subject.frame.origin.y < subjectOriginalFrame.origin.y {
            newY = subjectBg.frame.origin.y
        }
        
        subjectBg.frame.origin.x = newX
        subjectBg.frame.origin.y = newY
    }
    func handlerSubject(_ subject: UIView, _ dx: CGFloat, _ dy: CGFloat) {
        let newX = subject.frame.origin.x + dx
        let newY = subject.frame.origin.y + dy
        
        subject.frame.origin.x = newX
        subject.frame.origin.y = newY
    }
}




