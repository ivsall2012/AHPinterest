//
//  AHDiscoverNavVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/27/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit


protocol AHDiscoverNavDelegate: NSObjectProtocol {
    func discoverNavDidSelect(at index: Int)
}



let AHDiscoverNavCellHeight: CGFloat = 49.0
let AHDiscoverNavCellPadding: CGFloat = 20.0
let AHDiscoverNavCellFontSize: CGFloat = 17.0

class AHDiscoverNavVC: UICollectionViewController {
    weak var delegate: AHDiscoverNavDelegate?
    
    var categoryArr: [String]? {
        didSet {
            if categoryArr != nil {
                self.navHandler.categoryArr = categoryArr
            }
        }
    }
    let navHandler = AHDiscoverNavHandler()
    let layout = UICollectionViewFlowLayout()
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectionView?.setCollectionViewLayout(layout, animated: false)
    }
    
    func scrollToItemIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        navHandler.scrollToItem(at: indexPath, collectionView: self.collectionView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navCell = UINib(nibName: AHDiscoverNavCellID, bundle: nil)
        collectionView?.register(navCell, forCellWithReuseIdentifier: AHDiscoverNavCellID)
        
        collectionView?.delegate = navHandler
        collectionView?.dataSource = navHandler
        collectionView?.backgroundColor = UIColor.white
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = AHDiscoverNavCellPadding
        navHandler.discoverNavVC = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


}
