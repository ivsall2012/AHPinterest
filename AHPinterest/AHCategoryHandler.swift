//
//  AHCategoryHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/30/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHCategoryHandler: NSObject {
    weak var categoryVC: AHDiscoverCategoryVC!
    var categoryDataModels: [AHCategoryDataModel]?

}

extension AHCategoryHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension AHCategoryHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categoryDataModels = categoryDataModels else { return 0 }
        return categoryDataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryDataModels = categoryDataModels
            else {
                return UICollectionViewCell()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AHCategoryCellID, for: indexPath) as! AHCategoryCell
        cell.dataModel = categoryDataModels[indexPath.item]
        return cell
    }
}
