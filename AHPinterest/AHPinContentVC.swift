//
//  AHPinContentVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/18/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinContentVC: AHCollectionVC {
    let pinContentLayout = AHPinContentLayout()
    let pinContentLayoutHanlder = AHPinContentLayoutHandler()
    weak var pinVM: AHPinViewModel? {
        didSet {
            if let pinVM = pinVM {
                self.pinContentLayoutHanlder.pinVM = pinVM
                self.collectionView?.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        
        pinContentLayout.delegate = pinContentLayoutHanlder
        addLayout(layout: pinContentLayout, delegate: pinContentLayoutHanlder, dataSource: pinContentLayoutHanlder)
        
        
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
