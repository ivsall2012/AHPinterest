//
//  AHDiscoverPageVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/29/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDiscoverCategoryVC: AHPinVC {
    let contentLayout = AHDiscoverContentLayout()
    let contentLayoutHanlder = AHDiscoverContentLayoutHandler()
    

    var categoryName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: AHCategoryCellID, bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: AHCategoryCellID)
        
        contentLayoutHanlder.categoryVC = self
        insertLayoutToFront(layout: contentLayout, delegate: contentLayoutHanlder, dataSource: contentLayoutHanlder)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentLayoutHanlder.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}













