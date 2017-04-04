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
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Pattern"))
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = .init(top: 23, left: 5, bottom: 10, right: 5)
        viewModel = ViewModel(collectionView: collectionView!, reusableCellID: "cell")
        viewModel?.mainVC = self
        viewModel?.setup()
    }

}

