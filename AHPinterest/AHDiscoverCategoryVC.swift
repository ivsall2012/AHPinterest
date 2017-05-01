//
//  AHDiscoverPageVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/29/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDiscoverCategoryVC: AHPinVC {
    let contentLayout = AHDiscoverContentLayout()
    
    var contentVC: AHDiscoverContentVC?
    let group = DispatchGroup()
    var categoryName: String? {
        didSet {
            if let categoryName = categoryName {
                contentVC?.categoryName = categoryName
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let pageNib = UINib(nibName: AHPageCellID, bundle: nil)
        collectionView?.register(pageNib, forCellWithReuseIdentifier: AHPageCellID)
        
        contentVC = AHDiscoverContentVC(collectionViewLayout: UICollectionViewFlowLayout())
        contentLayout.delegate = self
        insertLayoutToFront(layout: contentLayout, delegate: self, dataSource: self)
        
        contentVC?.willMove(toParentViewController: self)
        self.addChildViewController(contentVC!)
        contentVC?.didMove(toParentViewController: self)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }

}

extension AHDiscoverCategoryVC: AHDiscoverContentLayoutDelegate {
    func discoverContentLayoutForContentHeight(layout: AHDiscoverContentLayout) -> CGFloat {
        let height = contentVC!.collectionViewLayout.collectionViewContentSize.height

        if height > 0.0 {
            return height
        }else{
            return 300.0
        }
    }
}

extension AHDiscoverCategoryVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AHPageCellID, for: indexPath) as! AHPageCell
        contentVC?.categoryName = self.categoryName
        cell.pageVC = contentVC
        return cell
    }
}














