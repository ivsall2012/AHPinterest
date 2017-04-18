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
    
    /// The section number is your layout.layoutSection
    /// You don't have to worry about section numbers, just return how many items you want to have within your layout.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionVC != nil, collectionVC!.layoutArray.count > 0 else {
            return 0
        }
        guard section < collectionVC!.layoutArray.count else {
            fatalError("section is out of bound")
        }
        
    
        let dataSource = collectionVC!.dataSources[section]
        return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    /// All cells belonged to your layout will be delivered here. Again, you don't have to care about indexPath.section. They're all yours!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionVC != nil else {
            fatalError("collectionVC is nil")
        }
        guard collectionVC!.layoutArray.count > 0 else {
            fatalError("layoutArray is empty")
        }
        guard indexPath.section < collectionVC!.layoutArray.count else {
            fatalError("section is out of bound")
        }
        
        let dataSource = collectionVC!.dataSources[indexPath.section]
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)

    }
    
    /// All supplement attributes will be delivered here. You can differentiate them by their kinds you registered. And within the kind, indexPaths are all yours.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard collectionVC != nil else {
            fatalError("collectionVC is nil")
        }

        // The supplement view could be from regular layout's supplement attributes
        if indexPath.section < collectionVC!.dataSources.count {
            let dataSource = collectionVC!.dataSources[indexPath.section]
            if let view = dataSource.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
                return view
            }
        }
        
        // Or from independent supplement layout's
        let normalizedSection = indexPath.section - collectionVC!.dataSources.count
        if normalizedSection < collectionVC!.supplementDataSources.count {
            let dataSource = collectionVC!.supplementDataSources[normalizedSection]
            if let view = dataSource.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
                return view
            }
        }
        
        fatalError("Not fount item with kind:\(kind) indexPath:\(indexPath)")
    }
}





