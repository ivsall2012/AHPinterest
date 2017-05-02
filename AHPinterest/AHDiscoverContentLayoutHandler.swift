//
//  AHDiscoverContentLayoutHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 5/1/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDiscoverContentLayoutHandler: NSObject {
    weak var categoryVC: AHDiscoverCategoryVC!
    var dataModels = [AHCategoryDataModel]()
    
    func reloadData() {
        if dataModels.isEmpty {
            AHNetowrkTool.tool.loadCategoryData(forCategoryName: categoryVC.categoryName!) { (dataModels) in
                if let dataModels = dataModels {
                    self.dataModels.removeAll()
                    self.dataModels.append(contentsOf: dataModels)
                    self.categoryVC.collectionView?.reloadData()
                }
            }
        }else{
            self.categoryVC.collectionView?.reloadData()
        }
    }
}



extension AHDiscoverContentLayoutHandler: UICollectionViewDelegate {
    
}

extension AHDiscoverContentLayoutHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard !dataModels.isEmpty else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AHCategoryCellID, for: indexPath) as! AHCategoryCell
        let dataModel = dataModels[indexPath.item]
        cell.dataModel = dataModel
        return cell
    }
}
