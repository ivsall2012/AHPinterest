//
//  AHDiscoverContainer.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/27/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDiscoverVC: UICollectionViewController {
    let navVC = AHDiscoverNavVC()
    let pageLayout = AHPageLayout()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollecitonView()
        
        setupNavVC()
    }

    func setupCollecitonView() {
        pageLayout.scrollDirection = .horizontal
        collectionView?.setCollectionViewLayout(pageLayout, animated: false)
    }
    
    func setupNavVC() {
        navVC.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: AHDiscoverNavCellHeight)
        navVC.willMove(toParentViewController: self)
        self.addChildViewController(navVC)
        navVC.didMove(toParentViewController: self)
        
        navVC.view.willMove(toSuperview: self.view)
        self.view.addSubview(navVC.view)
        navVC.view.didMoveToSuperview()
    }


}
