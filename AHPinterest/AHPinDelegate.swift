//
//  ViewModel.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit


class AHPinDelegate: NSObject {
    weak var pinVC: AHPinVC?
}



extension AHPinDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHDetailVC") as! AHDetailVC
        vc.pinVMs = pinVC?.pinDataSource.pinVMs
        vc.currentIndexPath = indexPath
        pinVC?.navigationController?.pushViewController(vc, animated: true)
    }
}









