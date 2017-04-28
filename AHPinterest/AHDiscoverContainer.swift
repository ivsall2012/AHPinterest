//
//  AHDiscoverContainer.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/27/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDiscoverContainer: UIViewController {
    weak var navVC: AHDiscoverNavVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AHDiscoverNavVC" {
            navVC = segue.destination as? AHDiscoverNavVC
        }
        super.prepare(for: segue, sender: sender)
    }



}
