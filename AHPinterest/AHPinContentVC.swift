//
//  AHPinContentVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/18/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinContentVC: AHPinVC {
    let pinContentLayout = AHPinContentLayout()
    let pinContentLayoutHanlder = AHPinContentLayoutHandler()
    override weak var pinVM: AHPinViewModel? {
        didSet {
            if let pinVM = pinVM {
                self.pinContentLayoutHanlder.pinVM = pinVM
                self.collectionView?.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinContentLayout.delegate = pinContentLayoutHanlder
        insertLayoutToFont(layout: pinContentLayout, delegate: pinContentLayoutHanlder, dataSource: pinContentLayoutHanlder)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
