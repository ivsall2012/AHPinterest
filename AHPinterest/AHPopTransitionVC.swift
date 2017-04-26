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
    var bgSnap: UIView?
    var presentingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let bgSnap = bgSnap{
            self.view.addSubview(bgSnap)
        }
        
        if let presentingView = presentingView {
            self.view.addSubview(presentingView)
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
        bgSnap?.removeFromSuperview()
        presentingView?.removeFromSuperview()
        previousPoint = nil
    }
    
    func touchMoved(to point:CGPoint) {
        guard let bgSnap = bgSnap, let presentingView = presentingView else {
            return
        }
        
        if previousPoint == nil {
            previousPoint = point
        }
        // do not use gesture's translation for delta offset here, it has performance problem
        let dx = point.x - previousPoint!.x
        let dy = point.y - previousPoint!.y
        previousPoint = point
        
        bgSnap.frame.origin.x = bgSnap.frame.origin.x + dx
        bgSnap.frame.origin.y = bgSnap.frame.origin.y + dy

        presentingView.frame.origin.x = presentingView.frame.origin.x + dx
        presentingView.frame.origin.y = presentingView.frame.origin.y + dy
    }
}
