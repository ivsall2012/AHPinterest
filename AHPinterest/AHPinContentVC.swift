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
        let navBar = AHPinNavBar.navBar()
        navBar.frame = CGRect(x: 0, y: 0, width: collectionView!.bounds.width, height: AHPinNavBarHeight)
        self.view.addSubview(navBar)
        
        navBar.pinVM = pinVM
        let navBarHandler = AHPinNavBarHandler()
        navBarHandler.contentVC = self
        addDelegate(delegate: navBarHandler)
        navBarHandler.navBar = navBar
        
        
        collectionView?.contentInset = .init(top: AHPinNavBarHeight, left: 0, bottom: 0, right: 0)
        
        pinContentLayout.delegate = pinContentLayoutHanlder
        insertLayoutToFont(layout: pinContentLayout, delegate: pinContentLayoutHanlder, dataSource: pinContentLayoutHanlder)
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }


}
