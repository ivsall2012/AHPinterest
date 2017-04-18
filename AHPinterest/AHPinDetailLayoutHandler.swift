//
//  AHPinContentHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinDetailLayoutHandler: NSObject {

}

extension AHPinDetailLayoutHandler: AHPinDetailLayoutDelegate {
    func AHPinDetailLayoutSize(index: IndexPath) -> CGSize {
        return CGSize(width: 0.0, height: 200.0)
    }
}

extension AHPinDetailLayoutHandler: UICollectionViewDelegate{
    
}

extension AHPinDetailLayoutHandler: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DummyCell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
