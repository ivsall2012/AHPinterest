//
//  AHPinContentHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/15/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinContentHandler: NSObject {

}

extension AHPinContentHandler: AHPinContentDelegate {
    func AHPinContentSize(index: IndexPath) -> CGSize {
        return CGSize(width: 0.0, height: 200.0)
    }
}

extension AHPinContentHandler: UICollectionViewDelegate{
    
}

extension AHPinContentHandler: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
