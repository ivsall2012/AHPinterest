//
//  AHShareModalVCViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/3/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHShareModalVC: UIViewController {
    var startingPoint: CGPoint?
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
        print("moved point")
    }
    
    func ended(point: CGPoint) {
        dismiss(animated: true, completion: nil)
    }
}













