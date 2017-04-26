//
//  AHPinContentVC.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/18/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinContentVC: AHPinVC {
    let popInteractiveHandler = AHPopInteractiveHandler()
    
    let pinContentLayout = AHPinContentLayout()
    let pinContentLayoutHanlder = AHPinContentLayoutHandler()
    
    var navBar: AHPinNavBar?
    
    // The current displaying main cell
    var presentingCell: AHPinContentCell? {
        return self.pinContentLayoutHanlder.presentingCell
    }
    override weak var pinVM: AHPinViewModel? {
        didSet {
            if let pinVM = pinVM {
                self.pinContentLayoutHanlder.pinVM = pinVM
                self.collectionView?.reloadData()
            }
        }
    }
    


}


// MARK:- VC Life Cycles
extension AHPinContentVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupContentLayout()
        setupPopTransition()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
extension AHPinContentVC {
    func setupPopTransition() {
        popInteractiveHandler.pinContentVC = self
        addDelegate(delegate: popInteractiveHandler)
    }
    
    func setupContentLayout() {
        collectionView?.contentInset = .init(top: AHPinNavBarHeight, left: 0, bottom: 0, right: 0)
        pinContentLayoutHanlder.pinContentVC = self
        pinContentLayout.delegate = pinContentLayoutHanlder
        insertLayoutToFont(layout: pinContentLayout, delegate: pinContentLayoutHanlder, dataSource: pinContentLayoutHanlder)
    }
    
    func setupNavBar(){
        navBar = AHPinNavBar.navBar()
        navBar!.frame = CGRect(x: 0, y: 0, width: collectionView!.bounds.width, height: AHPinNavBarHeight)
        self.view.addSubview(navBar!)
        
        navBar!.pinVM = pinVM
        let navBarHandler = AHPinNavBarHandler()
        navBarHandler.contentVC = self
        addDelegate(delegate: navBarHandler)
        navBarHandler.navBar = navBar
    }
}


// MARK:- Overrides for option animation from super classs

extension AHPinContentVC {
    override func optionsHandlerForFromCell(at point: CGPoint) -> UIView? {
        let view = super.optionsHandlerForFromCell(at: point)
        
        if view == nil {
            // super(AHPinVC) did return a cell, chekc if it's point within the presenting cell
            if self.presentingCell?.frame.contains(point) ?? false {
                return self.presentingCell
            }else{
                return nil
            }
        }else{
            return view
        }
        
    }
    
    override func optionsHandlerShouldAnimate(on cell: UIView) -> Bool {
        let shouldAnimate = super.optionsHandlerShouldAnimate(on: cell)
        if shouldAnimate == false {
            if let cell = cell as? AHPinContentCell  {
                return !cell.isSelected
            }
        }
        return shouldAnimate
        
    }
}






