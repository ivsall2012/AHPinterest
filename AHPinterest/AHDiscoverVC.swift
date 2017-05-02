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
    
    var pageVCs = [AHDiscoverCategoryVC]()
    
    var categoryArr = [String]()
    
    var itemIndex: Int = -1 {
        didSet {
            print("should scroll navVC")
            self.navVC.scrollToItemIndex(index: itemIndex)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView?.frame.origin.y = 64 + AHDiscoverNavCellHeight
        collectionView?.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0 )
        setupCollecitonView()
        
        setupNavVC()
        
    }

    
    
    func setupCollecitonView() {
        
        let pageCellNIb = UINib(nibName: AHPageCellID, bundle: nil)
        collectionView?.register(pageCellNIb, forCellWithReuseIdentifier: AHPageCellID)
        
        pageLayout.scrollDirection = .horizontal
        collectionView?.setCollectionViewLayout(pageLayout, animated: false)
    }
    
    func setupNavVC() {
        navVC.delegate = self
        navVC.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: AHDiscoverNavCellHeight)
        
        navVC.willMove(toParentViewController: self)
        self.addChildViewController(navVC)
        navVC.didMove(toParentViewController: self)
        
        
        navVC.view.willMove(toSuperview: self.view)
        self.view.addSubview(navVC.view)
        navVC.view.didMoveToSuperview()
        
        
        AHNetowrkTool.tool.loadCategoryNames { (categoryArr) in
            if let categoryArr = categoryArr, !categoryArr.isEmpty {
                self.categoryArr.append(contentsOf: categoryArr)
                self.navVC.categoryArr = self.categoryArr
                self.setupPageVCs()
            }
        }
    }
    
    func setupPageVCs(){
        for i in 0..<categoryArr.count {
            let vc = createPageVC(i)
            pageVCs.append(vc)
        }
        self.collectionView?.reloadData()
    }
    
    func createPageVC(_ index:Int) -> AHDiscoverCategoryVC {
        let vc = AHDiscoverCategoryVC()
        vc.showLayoutHeader = true
        vc.categoryName = categoryArr[index]
        // setup VC related
        vc.willMove(toParentViewController: self)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        return vc
    }


}

extension AHDiscoverVC {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let items = collectionView?.visibleCells
        if let items = items, items.count == 1 {
            if let indexPath = collectionView?.indexPath(for: items.first!) {
                self.itemIndex = indexPath.item
            }else{
                fatalError("It has an visible cell without indexPath??")
            }
            
        }else{
            print("visible items have more then 1, problem?!")
        }
    }
}

extension AHDiscoverVC: AHDiscoverNavDelegate {
    func discoverNavDidSelect(at index: Int) {
        print("should scroll main vc")
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
    }
}

extension AHDiscoverVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // At first return, collecitonView.bounds.size is 1000.0 x 980.0
        return CGSize(width: screenSize.width, height: screenSize.height)
    }
    
}

extension AHDiscoverVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AHPageCellID, for: indexPath) as! AHPageCell
        
        guard !categoryArr.isEmpty else {
            return cell
        }
        
        let categoryName = categoryArr[indexPath.item]
        let pageVC = pageVCs[indexPath.item]
        pageVC.refreshLayout.enableHeaderRefresh = false
        pageVC.sectionTitle = categoryName
        cell.pageVC = pageVC
        return cell
    }
}



