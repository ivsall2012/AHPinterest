//
//  AHDataSourceCenter.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/16/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDataSourceCenter: NSObject {
    weak var collectionVC: AHCollectionVC?
    
    init(collectionVC: AHCollectionVC) {
        self.collectionVC = collectionVC
    }
}

extension AHDataSourceCenter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // each layout has its own section
        return collectionVC?.layoutArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionVC != nil, collectionVC!.layoutArray.count > 0 else {
            return 0
        }
        guard section >= collectionVC!.layoutArray.count else {
            fatalError("section is out of bound")
        }
        
        let dataSource = collectionVC!.dataSources[section]
        return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionVC != nil else {
            fatalError("collectionVC is nil")
        }
        guard collectionVC!.layoutArray.count > 0 else {
            fatalError("layoutArray is empty")
        }
        guard indexPath.section >= collectionVC!.layoutArray.count else {
            fatalError("section is out of bound")
        }
        
        let dataSource = collectionVC!.dataSources[indexPath.section]
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard collectionVC != nil else {
            fatalError("collectionVC is nil")
        }
        
        guard collectionVC!.layoutArray.count > 0 else {
            fatalError("layoutArray is empty")
        }
        guard indexPath.section >= collectionVC!.layoutArray.count else {
            fatalError("section is out of bound")
        }
        
        let dataSource = collectionVC!.dataSources[indexPath.section]
        return dataSource.collectionView(v, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}





