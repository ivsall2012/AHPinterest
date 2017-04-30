//
//  AHPinDataSource.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/13/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinDataSource: NSObject {
    weak var pinVC: AHPinVC?
    var sectionTitle: String?
    var pinVMs = [AHPinViewModel]()
    
}

extension AHPinDataSource : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pinCell = collectionView.dequeueReusableCell(withReuseIdentifier: AHPinCellIdentifier, for: indexPath) as! AHPinCell
        guard !pinVMs.isEmpty else {
            fatalError("IndexPath:\(indexPath) out of bound")
        }
        
        let pinVM = pinVMs[indexPath.item]
        
        pinCell.pinVM = pinVM
        return pinCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == AHPinLayoutHeaderKind {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: AHPinLayoutHeaderKind, withReuseIdentifier: AHPinLayoutHeaderKind, for: indexPath) as! AHPinLayoutHeader
            if let sectionTitle = sectionTitle {
                header.headerLabel.text = sectionTitle
            }
            return header
        }
        
        fatalError("no header cell")
    }
    
}




// MARK:- Data Netowrking Related
extension AHPinDataSource {
    func loadNewData(completion: ((_ success: Bool)->Swift.Void)? ){
        AHNetowrkTool.tool.loadNewData { (newPinVMs) in
            self.pinVMs.removeAll()
            self.pinVMs.append(contentsOf: newPinVMs)
            self.pinVC?.collectionView?.reloadData()
            completion?(true)
        }
    }
    
    func loadOlderData(completion: ((_ success: Bool)->Swift.Void)? ){
        guard let pinLayout = pinVC?.pinLayout else {
            return
        }
        AHNetowrkTool.tool.loadNewData { (newPinVMs) in
            if self.pinVMs.count == 0 {
                self.pinVMs.append(contentsOf: newPinVMs)
                self.pinVC?.collectionView?.reloadData()
                completion?(true)
            }else{
                var starter = self.pinVMs.count
                var indexPaths = [IndexPath]()
                
                for _ in newPinVMs {
                    let indexPath = IndexPath(item: starter, section: pinLayout.layoutSection)
                    indexPaths.append(indexPath)
                    starter += 1
                }
                self.pinVMs.append(contentsOf: newPinVMs)
                self.pinVC?.collectionView?.performBatchUpdates({
                     self.pinVC?.collectionView?.insertItems(at: indexPaths)
                    }, completion: { (_) in
                        completion?(true)
                })
            }
            
        }
    }
}
