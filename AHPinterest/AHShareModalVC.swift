//
//  AHShareModalVCViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/3/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHShareModalVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
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













