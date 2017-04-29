//
//  AHDiscoverNavVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/27/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit


let AHDiscoverNavCellHeight: CGFloat = 49.0
let AHDiscoverNavCellPadding: CGFloat = 20.0
let AHDiscoverNavCellFontSize: CGFloat = 17.0

class AHDiscoverNavVC: UICollectionViewController {
    
    let navHandler = AHDiscoverNavHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navCell = UINib(nibName: AHDiscoverNavCellID, bundle: nil)
        collectionView?.register(navCell, forCellWithReuseIdentifier: AHDiscoverNavCellID)
        
        collectionView?.delegate = navHandler
        collectionView?.dataSource = navHandler
        collectionView?.contentInset = .zero
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = AHDiscoverNavCellPadding
        navHandler.discoverNavVC = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navHandler.reload()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


}
