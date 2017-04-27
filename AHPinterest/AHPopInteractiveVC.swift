//
//  AHPopTransitionVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/25/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHPopInteractiveVCDelegate: NSObjectProtocol {
    func popInteractiveVCShouldPopController(bool: Bool)
}


class AHPopInteractiveVC: UIViewController {
    weak var delegate: AHPopInteractiveVCDelegate?
    
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
    var background: UIView? {
        didSet {
            if let background = background {
                backgroundMask = UIView(frame: background.bounds)
                backgroundMask?.alpha = 1.0
                backgroundMask?.backgroundColor = UIColor.white
                background.addSubview(backgroundMask!)
                self.view.insertSubview(background, at: 0)
                background.transform = CGAffineTransform(scaleX: 1.5, y: 1.6)
            }
        }
    }
    var backgroundMask: UIView?
    
    var subjectFinalFrame = CGRect.zero
    
    var subjectOriginalFrame = CGRect.zero
    var subjectBgOriginalFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
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
        background?.removeFromSuperview()
        previousPoint = nil
    }
    
    func touchMoved(to point:CGPoint) {
        guard let subjectBg = subjectBg, let subject = subject, let backgroundMask = backgroundMask, let background = background else {
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
        handleSubject(subject, dx, dy, ratio)
        handleBackground(background, backgroundMask, dx, dy, ratio)

        
    }
    
    func touchEnded() {
        let delta = subject!.frame.origin.y - subjectBgOriginalFrame.origin.y
        if delta < 150 {
            self.dismiss(animated: false, completion: nil)
            delegate?.popInteractiveVCShouldPopController(bool: false)
        }else{
            print("delta:\(delta)")
            self.subjectBg?.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundMask?.alpha = 0.0
                self.subject?.frame = self.subjectFinalFrame
                self.background?.transform = .identity
                }, completion: { (_) in
                    self.backgroundMask = nil
                    self.dismiss(animated: false, completion: nil)
                    self.delegate?.popInteractiveVCShouldPopController(bool: true)
            })
        }
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
            subjectBg.frame.origin.x = newX
            subjectBg.frame.origin.y = newY
            subjectBg.alpha = ratio * 0.5
        }
        
        
    }
    func handleSubject(_ subject: UIView, _ dx: CGFloat, _ dy: CGFloat, _ ratio: CGFloat) {
        let newX = subject.frame.origin.x + dx
        let newY = subject.frame.origin.y + dy
        
        if subject.frame.origin.y < subjectOriginalFrame.origin.y {
            
            subject.frame.origin.x = newX
            subject.frame.origin.y = newY
        }else{
            
            let scale = CGAffineTransform(scaleX: ratio, y: ratio)
            
            subject.transform = scale
            subject.frame.origin.x = newX
            subject.frame.origin.y = newY
        }
        
    }
    func handleBackground(_ background: UIView, _ mask: UIView, _ dx: CGFloat, _ dy: CGFloat, _ ratio: CGFloat){
        mask.alpha = ratio
        background.transform = CGAffineTransform(scaleX: 1.5 * ratio, y: 1.5 * ratio)
    }
}




