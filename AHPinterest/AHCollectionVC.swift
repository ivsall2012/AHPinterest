//
//  AHCollectionVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/16/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

// This protocol is specifically for independent/separate globel supplement layout to ignore regular item dataSource methods, such as the followings.
// Note that if you have your in-section supplement attributes included in your regular layout, just comfirm to UICollectionViewDataSource and do stuff there.
//protocol AHCollectionViewDataSource {
//    optional func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    
//    optional func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//}



class AHCollectionVC: UICollectionViewController {
    let layoutRouter = AHLayoutRouter()
    fileprivate(set) lazy var delegateCenter : AHDelegatesCenter = {[weak self] () -> AHDelegatesCenter in
        return AHDelegatesCenter(collectionVC: self!)
    }()
    fileprivate(set) lazy var dataSourceCenter : AHDataSourceCenter = {[weak self] () -> AHDataSourceCenter in
        return AHDataSourceCenter(collectionVC: self!)
    }()
    
    fileprivate(set) var delegates = [UICollectionViewDelegate]()
    fileprivate(set) var dataSources = [UICollectionViewDataSource]()
    
    fileprivate(set) var generalDelegates = [UICollectionViewDelegate]()
    
    var layoutArray: [UICollectionViewLayout] {
        return self.layoutRouter.layoutArray
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layoutRouter)
        collectionView?.delegate = delegateCenter
        collectionView?.dataSource = dataSourceCenter
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView?.setCollectionViewLayout(layoutRouter, animated: false)
        collectionView?.delegate = delegateCenter
        collectionView?.dataSource = dataSourceCenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    

}

// MARK:- Public API
extension AHCollectionVC {
    func addLayout(layout: AHLayout, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource){
        layoutRouter.add(layout: layout)
        delegates.append(delegate)
        dataSources.append(dataSource)
    }
    func addGlobelSupplement(layout: AHLayout, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource){
        layoutRouter.addSupplementLayout(layout: layout)
        delegates.append(delegate)
        dataSources.append(dataSource)
    }
    func insertLayoutToFront(layout: AHLayout, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        layoutRouter.insert(layout: layout, at: 0)
        delegates.insert(delegate, at: 0)
        dataSources.insert(dataSource, at: 0)
    }
    
    // This delegate will receive all collectionViewDelegate's events, can act as a globel listener.
    func addGlobelDelegate(delegate: UICollectionViewDelegate) {
        generalDelegates.append(delegate)
    }

}











