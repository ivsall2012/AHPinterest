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
    var subject: UIView?
    
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
        
        subjectBg.frame.origin.x = subjectBg.frame.origin.x + dx
        subjectBg.frame.origin.y = subjectBg.frame.origin.y + dy

        subject.frame.origin.x = subject.frame.origin.x + dx
        subject.frame.origin.y = subject.frame.origin.y + dy
    }
}
