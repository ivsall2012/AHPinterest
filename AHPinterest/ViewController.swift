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
        viewModel = ViewModel(collectionView: collectionView!, reusablePinCellID: "PinCell")
        viewModel?.mainVC = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AHRefershUI.show()
        viewModel?.loadNewData(completion: { (success) in
            AHRefershUI.dismiss()
            if success {
                // dismiss refresh control
            }else{
                // do something about it and dismiss refresh control too
            }
        })
    }

}

