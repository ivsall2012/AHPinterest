//
//  ViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinVC: AHCollectionVC {
//    let pinContentLayout = AHPinContentLayout()
//    let pinContentLayoutHanlder = AHPinContentLayoutHandler()
    weak var pinVM: AHPinViewModel? 
    
    
    let pinLayout = AHPinLayout()
    let refreshLayout = AHRefreshLayout()
    let pinDataSource = AHPinDataSource()
    let optionsHandler = AHOptionsHandler()
    
    // should the VC refreshes data at first loading
    var initialAutoRefresh = false
    
    var showContentPin = false
}


// MARK:- VC Cycles
extension AHPinVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        collectionView?.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false

        collectionView?.register(AHRefreshHeader.self, forSupplementaryViewOfKind: AHHeaderKind, withReuseIdentifier: AHHeaderKind)
        
        collectionView?.register(AHRefreshFooter.self, forSupplementaryViewOfKind: AHFooterKind, withReuseIdentifier: AHFooterKind)
        
        setup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !initialAutoRefresh {
            initialAutoRefresh = true
            AHRefershUI.show()
            pinDataSource.loadNewData(completion: { (success) in
                AHRefershUI.dismiss()
                if success {
                    // dismiss refresh control
                }else{
                    // do something about it and dismiss refresh control too
                }
            })
        }
        
    }
}

// MARK:- Setups
extension AHPinVC {
    func setup() {

        setupPinLayout()
        setupRefreshLayout()
        setupOptionsHandler()
    }
    
    func setupRefreshLayout() {
        let layoutHanlder = AHRefreshLayoutHandler()
        layoutHanlder.pinVC = self
        refreshLayout.delegate = layoutHanlder
        refreshLayout.enableFooterRefresh = true
        refreshLayout.enableHeaderRefresh = true
        addGlobelSupplement(layout: refreshLayout, delegate: layoutHanlder, dataSource: layoutHanlder)
    }
    
    func setupPinLayout() {
        pinDataSource.pinVC = self
        
        let pinDelegate = AHPinDelegate()
        pinDelegate.pinVC = self

        let layoutHanlder = AHLayoutHandler()
        layoutHanlder.pinVC = self
        pinLayout.delegate = layoutHanlder
        
        addLayout(layout: pinLayout, delegate: pinDelegate, dataSource: pinDataSource)
    }
    
    func setupOptionsHandler() {
        optionsHandler.pinVC = self
        optionsHandler.collectionView = collectionView
    }
    
}





