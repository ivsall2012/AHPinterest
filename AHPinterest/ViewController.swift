//
//  ViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var viewModel: ViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = .init(top: 23, left: 5, bottom: 10, right: 5)
        viewModel = ViewModel(collectionView: collectionView!, reusablePinCellID: "PinCell")
        viewModel?.mainVC = self
        viewModel?.loadNewData(completion: { (success) in
            if success {
                // dismiss refresh control
            }else{
                // do something about it and dismiss refresh control too
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }

}

