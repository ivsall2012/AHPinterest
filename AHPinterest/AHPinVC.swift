//
//  ViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit



class AHPinVC: AHCollectionVC, AHTransitionProperties {
    
    weak var pinVM: AHPinViewModel?
    
    var itemIndex: Int = -1
    
    
    // This cell is the one already being selected which triggered the push, will be used by the next pushed VC(AHDetailVC) from this VC(AHPinVC or AHDetailVC).
    weak var selectedCell: AHPinCell? {
        let index = IndexPath(item: itemIndex, section: self.pinLayout.layoutSection)
        // scroll using system method to make the cell visible
        
        if let navVC = self.navigationController as? AHNavigationController, navVC.operation  == .push {
            return self.collectionView!.cellForItem(at: index) as? AHPinCell
        }
        self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.bottom, animated: false)
        self.collectionView?.layoutIfNeeded()
        // now the cell is not nil
        let cell = self.collectionView!.cellForItem(at: index) as? AHPinCell
        // custom scroll to make cell center
        self.scrollToItem(cell: cell!)
        self.collectionView?.layoutIfNeeded()
        return cell
    }
    
    let pinLayout = AHPinLayout()
    
    let refreshLayout = AHRefreshLayout()
    fileprivate let refreshLayoutHanlder = AHRefreshLayoutHandler()
    
    let pinDataSource = AHPinDataSource()
    let pinDelegate = AHPinDelegate()
    
    var optionsHandler: AHOptionsHandler?
    
    
    // should the VC refreshes data at first loading
    var initialAutoRefresh = true
    
    var showLayoutHeader = false
    
    
}


// MARK:- VC Cycles
extension AHPinVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.isNavigationBarHidden = true
        collectionView?.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        let headerNib = UINib(nibName: "AHPinLayoutHeader", bundle: nil)
        collectionView?.register(headerNib, forSupplementaryViewOfKind: AHPinLayoutHeaderKind, withReuseIdentifier: AHPinLayoutHeaderKind)
        
        collectionView?.register(AHRefreshHeader.self, forSupplementaryViewOfKind: AHHeaderKind, withReuseIdentifier: AHHeaderKind)
        
        collectionView?.register(AHRefreshFooter.self, forSupplementaryViewOfKind: AHFooterKind, withReuseIdentifier: AHFooterKind)
        
        setup()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if initialAutoRefresh {
            initialAutoRefresh = false
            AHRefershUI.show()
            pinDataSource.loadNewData(completion: { (success) in
                AHRefershUI.dismiss()
                if success {
                    // dismiss refresh control
                }else{
                    // do something about it and dismiss refresh control too
                }
            })
        }
        
        
        
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
}

// MARK:- Setups
extension AHPinVC {
    
    func setup() {

        setupPinLayout()
        setupRefreshLayout()
        setupOptionsHandler()
    }
    
    func setupRefreshLayout() {
        refreshLayoutHanlder.pinVC = self
        refreshLayout.delegate = refreshLayoutHanlder
        refreshLayout.enableFooterRefresh = true
        refreshLayout.enableHeaderRefresh = true
        addGlobelSupplement(layout: refreshLayout, delegate: refreshLayoutHanlder, dataSource: refreshLayoutHanlder)
    }
    
    func setupPinLayout() {
        pinDataSource.pinVC = self
        
        pinDelegate.pinVC = self

        let layoutHanlder = AHLayoutHandler()
        layoutHanlder.pinVC = self
        pinLayout.delegate = layoutHanlder
        
        addLayout(layout: pinLayout, delegate: pinDelegate, dataSource: pinDataSource)
    }
    
    func setupOptionsHandler() {
        optionsHandler = AHOptionsHandler(presenterVC: self, targetView: self.collectionView!, delegate: self)
    }
    
    func scrollToCell() {
        let index = IndexPath(item: itemIndex, section: self.pinLayout.layoutSection)
        
        // scroll using system method to make the cell visible
        self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.bottom, animated: false)
        self.collectionView?.layoutIfNeeded()
        
        // now the cell is not nil
        let cell = self.collectionView!.cellForItem(at: index) as? AHPinCell
        self.scrollToItem(cell: cell!)
        self.collectionView?.layoutIfNeeded()
    }
    
    func scrollToItem(cell: AHPinCell) {
        let relativeP = cell.convert(cell.center, to: collectionView)
        if relativeP.y < collectionView!.frame.size.height * 0.5 {
            // the cell is on the upper half of the screen
            return
        }
        // scroll to make the cell center
        let pt = CGPoint(x: 0, y: cell.center.y - collectionView!.frame.size.height * 0.5)
        collectionView?.setContentOffset(pt, animated: false)
    }
    
}

// MARK: - Delegates

extension AHPinVC: AHOptionsHandlerDelegate {
    func optionsHandlerForFromCell(at point: CGPoint) -> UIView? {
        if let indexPath = collectionView?.indexPathForItem(at: point), let cell = collectionView?.cellForItem(at: indexPath) {
            return cell
        }else{
            return nil
        }
    }
    
    func optionsHandlerShouldAnimate(on cell: UIView) -> Bool {
        if let cell = cell as? AHPinCell {
            // if not selected, then pop the animation
            return !cell.isSelected
        }else{
            return false
        }
        
    }
}



extension AHPinVC: AHTransitionPushFromDelegate {
    func transitionPushFromSelectedCell() -> AHPinCell? {
        return self.selectedCell
    }
}

extension AHPinVC : AHTransitionPopToDelegate {
    func transitionPopToSelectedCell() -> AHPinCell? {
        return self.selectedCell
    }
}










