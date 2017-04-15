//
//  ViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinVC: UICollectionViewController {
    let dataSource = AHPinDataSource()
    let refreshController = AHRefreshControl()
    let pinDelegate = AHPinDelegate()
    let detailVC = AHDetailVC()
    let layoutHandler = AHLayoutHandler()
    let optionsHandler = AHOptionsHandler()
    let detailHanlder = AHDetailHandler()
    var pinVMs = [AHPinViewModel]() {
        didSet {
            self.layoutHandler.pinVMs = pinVMs
            self.detailHanlder.pinVMs = pinVMs
            self.dataSource.pinVMs = pinVMs
        }
    }
}


// MARK:- VC Cycles
extension AHPinVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = AHCollectionViewInset
        
        // Call mainSetups first
        mainSetups()
        
        setupDetailHandler()
        setupRefreshControl()
        setupOptionsHandler()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AHRefershUI.show()
        loadNewData(completion: { (success) in
            AHRefershUI.dismiss()
            if success {
                // dismiss refresh control
            }else{
                // do something about it and dismiss refresh control too
            }
        })
    }
}

// MARK:- Setups
extension AHPinVC {
    func mainSetups() {
        setupPinDelegate()
        setupDataSource()
        setupLayoutHandler()
    }
    
    func setupDetailHandler(){
        detailHanlder.pinVC = self
    }
    
    func setupPinDelegate() {
        collectionView?.delegate = pinDelegate
        pinDelegate.pinVC = self
        pinDelegate.refreshController = refreshController
        pinDelegate.detailHandler = detailHanlder
    }
    
    func setupDataSource() {
        collectionView?.dataSource = dataSource
        dataSource.refreshController = refreshController
    }
    
    func setupRefreshControl() {
        refreshController.pinVC = self
        refreshController.collectionView = collectionView
    }
    
    func setupLayoutHandler() {
        let layoutRouter = AHLayoutRouter()
        collectionView?.setCollectionViewLayout(layoutRouter, animated: false)
        
        let pinLayout = AHPinLayout()
        layoutRouter.add(layout: pinLayout)
        pinLayout.delegate = layoutHandler
    }
    
    func setupOptionsHandler() {
        optionsHandler.pinVC = self
        optionsHandler.collectionView = collectionView
    }
    
}


// MARK:- Data Netowrking Related
extension AHPinVC {
    func loadNewData(completion: ((_ success: Bool)->Swift.Void)? ){
        AHNetowrkTool.tool.loadNewData { (newPinVMs) in
            self.pinVMs.removeAll()
            self.pinVMs.append(contentsOf: newPinVMs)
            self.collectionView?.reloadData()
            completion?(true)
        }
    }
    
    func loadOlderData(completion: ((_ success: Bool)->Swift.Void)? ){
        AHNetowrkTool.tool.loadNewData { (newPinVMs) in
            if self.pinVMs.count == 0 {
                self.pinVMs.append(contentsOf: newPinVMs)
                self.collectionView?.reloadData()
                completion?(true)
            }else{
                var starter = self.pinVMs.count
                var indexPaths = [IndexPath]()
                
                for _ in newPinVMs {
                    let indexPath = IndexPath(item: starter, section: 0)
                    indexPaths.append(indexPath)
                    starter += 1
                }
                self.pinVMs.append(contentsOf: newPinVMs)
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.insertItems(at: indexPaths)
                    }, completion: { (_) in
                        completion?(true)
                })
            }
            
        }
    }
}



