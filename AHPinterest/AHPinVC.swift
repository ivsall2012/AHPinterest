//
//  ViewController.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

protocol AHPinVCDelegate: NSObjectProtocol {
    func pinVCForContentCell(indexPath: IndexPath) -> AHPinContentCell?
}


class AHPinVC: AHCollectionVC {
    weak var delegate: AHPinVCDelegate?
    weak var pinVM: AHPinViewModel? 
    var detailVCAnimator = AHDetailVCAnimator()
    
    let pinLayout = AHPinLayout()
    
    let refreshLayout = AHRefreshLayout()
    fileprivate let refreshLayoutHanlder = AHRefreshLayoutHandler()
    
    let pinDataSource = AHPinDataSource()
    let pinDelegate = AHPinDelegate()
    
    let optionsHandler = AHOptionsHandler()
    
    
    // should the VC refreshes data at first loading
    var initialAutoRefresh = true
    
    var showLayoutHeader = false
    
    func triggeredRefresh() {
        refreshLayoutHanlder.refreshManually(scrollView: collectionView!)
    }
}


// MARK:- VC Cycles
extension AHPinVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
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
        optionsHandler.pinVC = self
        optionsHandler.collectionView = collectionView
    }
    
}

extension AHPinVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .none {
            return nil
        }
        if operation == .pop {
            return nil
        }
        let detailVC = toVC as! AHDetailVC
        self.delegate = detailVC
        detailVCAnimator.delegate = self
        detailVCAnimator.state = operation
        return detailVCAnimator
    }
}

extension AHPinVC: AHDetailVCAnimatorDelegate {
    func detailVCAnimatorForSelectedCell() -> AHPinCell? {
        return pinDelegate.selectedCell
    }
    
    func detailVCAnimatorForContentCell() -> AHPinContentCell? {
        if let selectedPath = pinDelegate.selectedPath {
            return delegate?.pinVCForContentCell(indexPath: selectedPath)
        }
        return nil
    }
    
    func calculateImageHeight(imageSize: CGSize, newWidth: CGFloat) -> CGFloat {
        let newHeight = newWidth * imageSize.height / imageSize.width
        return newHeight
    }
}










