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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if bgSnap != nil {
            self.view.addSubview(bgSnap!)
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
        previousPoint = nil
    }
    
    func touchMoved(to point:CGPoint) {
        guard let bgSnap = bgSnap else {
            return
        }
        
        if previousPoint == nil {
            previousPoint = point
        }
        
        let dx = point.x - previousPoint!.x
        let dy = point.y - previousPoint!.y
        previousPoint = point
        
        bgSnap.frame.origin.x = bgSnap.frame.origin.x + dx
        bgSnap.frame.origin.y = bgSnap.frame.origin.y + dy

    }
}
