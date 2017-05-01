//
//  AHDiscoverContentVCCollectionViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 5/1/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AHDiscoverContentVC: UICollectionViewController {
    var categoryDataModels = [AHCategoryDataModel]()
    var categoryName: String?  {
        didSet {
            if let categoryName = categoryName {
                AHNetowrkTool.tool.loadCategoryData(forCategoryName: categoryName, completion: { (dataModels) in
                    
                    if let dataModels = dataModels {
                        self.categoryDataModels.removeAll()
                        self.categoryDataModels.append(contentsOf: dataModels)
                    }
                    
                })
            }
        }
    }
    
    var finishedLoadingCallback: ( () -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        
        collectionView?.contentInset = .zero
        
        let categoryCellNib = UINib(nibName: AHCategoryCellID, bundle: nil)
        collectionView?.register(categoryCellNib, forCellWithReuseIdentifier: AHCategoryCellID)
        
        collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let change = change as? [NSKeyValueChangeKey: NSValue] {
            if let size = change[NSKeyValueChangeKey.newKey] {
                if size.cgSizeValue.height > 0.0 {
                    finishedLoadingCallback?()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
}

extension AHDiscoverContentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard !categoryDataModels.isEmpty else {
            return CGSize.zero
        }
        
        let fullWidth = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right) - 40
        let halfWidth = fullWidth / 2.0 - 16
        
        let dataModel = categoryDataModels[indexPath.item]
        if dataModel.isFullWidth {
            return CGSize(width: fullWidth, height: 200.0)
        }else{
            return CGSize(width: halfWidth, height: 200.0)
        }
        
    }
}

extension AHDiscoverContentVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryDataModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AHCategoryCellID, for: indexPath) as! AHCategoryCell
        let dataModel = categoryDataModels[indexPath.item]
        cell.dataModel = dataModel
        return cell
    }
}
















