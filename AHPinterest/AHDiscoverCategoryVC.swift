//
//  AHDiscoverPageVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/29/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDiscoverCategoryVC: UICollectionViewController {
    var categoryDataModels = [AHCategoryDataModel]()
    var categoryHandler = AHCategoryHandler()
    var categoryName: String? {
        didSet {
            if let categoryName = categoryName {
                
                AHNetowrkTool.tool.loadCategoryData(forCategoryName: categoryName, completion: { (dataModels) in
                    
                    if let dataModels = dataModels {
                        self.categoryDataModels.removeAll()
                        self.categoryDataModels.append(contentsOf: dataModels)
                        self.categoryHandler.categoryDataModels = self.categoryDataModels
                        self.collectionView?.reloadData()
                    }
                    
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.orange
//        let nib = UINib(nibName: AHCategoryCellID, bundle: nil)
//        collectionView?.register(nib, forCellWithReuseIdentifier: AHCategoryCellID)
//        collectionView?.delegate = categoryHandler
//        collectionView?.dataSource = categoryHandler
//        let flowLayout = AHCategoryLayout()
//        collectionView?.setCollectionViewLayout(flowLayout, animated: false)
//        insertLayoutToFront(layout: flowLayout, delegate: categoryHandler, dataSource: categoryHandler)
//        flowLayout.itemSize = CGSize(width: 300, height: 100)
    }
}










