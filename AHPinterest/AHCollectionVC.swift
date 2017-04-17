//
//  AHCollectionVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/16/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHCollectionVC: UICollectionViewController {
    let layoutRouter = AHLayoutRouter()
    fileprivate(set) lazy var delegateCenter : AHDelegatesCenter = {
        return AHDelegatesCenter(collectionVC: self)
    }()
    fileprivate(set) lazy var dataSourceCenter : AHDataSourceCenter = {
        return AHDataSourceCenter(collectionVC: self)
    }()
    
    fileprivate(set) var delegates = [UICollectionViewDelegate]()
    fileprivate(set) var dataSources = [UICollectionViewDataSource]()
    
    var layoutArray: [UICollectionViewLayout] {
        return self.layoutRouter.layoutArray
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    

}

// MARK:- Public API
extension AHCollectionVC {
    func addLayout(layout: UICollectionViewLayout, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource){
        layoutRouter.add(layout: layout)
        delegates.append(delegate)
        dataSources.append(dataSource)
    }
}
