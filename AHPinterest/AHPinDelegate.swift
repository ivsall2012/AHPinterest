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

extension AHPinDelegate: UICollectionViewDelegate, AHDetailVCDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = AHPageLayout()
        let vc = AHDetailVC(collectionViewLayout: layout)
        
        vc.pinVMs = pinVC?.pinDataSource.pinVMs
        vc.delegate = self
        vc.itemIndex = indexPath.item
        pinVC?.itemIndex = indexPath.item
        pinVC?.navigationController?.pushViewController(vc, animated: true)
        print("pushing indexItem:\(pinVC!.itemIndex)")
        
        // FIXME: Need an efficent way to tell pinVC that the custom push transition animation is finished and then scrollToCell()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pinVC?.scrollToCell()
        }
    }
    
    
    func detailVCDidChangeTo(item: Int) {
        pinVC?.itemIndex = item
    }
}









