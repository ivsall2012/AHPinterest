//
//  AHPhotoBrowser.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/30/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit


let AHDetailCellMargin: CGFloat = 5.0
let screenSize: CGSize = UIScreen.main.bounds.size

private let reuseIdentifier = "AHDetailCell"



class AHDetailVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var transitionAnimator = AHTransitionAnimator()
    
    var pinVMs: [AHPinViewModel]?
    var currentIndexPath: IndexPath? {
        didSet {
            if let currentIndexPath = currentIndexPath {
                // one of the two places that currentItem get modified
                AHPublicServices.shared.currentItem = currentIndexPath.item
            }
        }
    }
    
    weak var selectedCell: AHPinCell?{
        guard let currentIndexPath = currentIndexPath else { return nil }
        
        let contentVC = cellVCs[currentIndexPath.item]
        return contentVC.selectedCell
    }
    
    weak var presentingCell: AHPinContentCell?{
        guard let currentIndexPath = currentIndexPath else { return nil }
        
        let contentVC = cellVCs[currentIndexPath.item]
        return contentVC.presentingCell
    }
    
    fileprivate var cellVCs = [AHPinContentVC]()
    // the scrollToItem when transitioning from pinVC to detailVC, which does only once
    fileprivate var initialScroll = false
    
    


}

// MARK:- VC Cycles
extension AHDetailVC {
    override func viewDidLoad() {
        super.viewDidLoad()
//        AHPublicServices.shared.navigatonController?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        collectionView?.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView?.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let layout = AHDetailVCLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        layout.scrollDirection = .horizontal
        
        guard let pinVMs = pinVMs else {
            return
        }
        
        for _ in pinVMs {
            let vc = createPinVC()
            cellVCs.append(vc)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
//        AHPublicServices.shared.navigatonController?.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !initialScroll {
            currentIndexPath?.section = 0
            collectionView.scrollToItem(at: currentIndexPath!, at: UICollectionViewScrollPosition.right, animated: false)
            
            
            //            cellVC.animateNavBar()
            initialScroll = true
        }
        
    }
}



// MARK:- Helper Methods
extension AHDetailVC {
    func createPinVC() -> AHPinContentVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHPinContentVC") as! AHPinContentVC
        vc.refreshLayout.enableHeaderRefresh = false
        vc.showLayoutHeader = true
//        vc.initialAutoRefresh = false
        
        // setup VC related
        vc.willMove(toParentViewController: self)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        return vc
    }

}


extension AHDetailVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let items = collectionView.visibleCells
        if items.count == 1 {
            currentIndexPath = collectionView.indexPath(for: items.first!)
            print("current item:\(currentIndexPath?.item)")
        }else{
            print("visible items have more then 1, problem?!")
        }
    }
}


extension AHDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // At first return, collecitonView.bounds.size is 1000.0 x 980.0
        return CGSize(width: screenSize.width, height: screenSize.height)
    }
    
}

extension AHDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let pinVMs = pinVMs else {
            return 0
        }
        return pinVMs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AHDetailCell
        
        guard let pinVMs = pinVMs else {
            return cell
        }
        
        let pinVM = pinVMs[indexPath.item]
        let cellVC = cellVCs[indexPath.item]
        cellVC.pinVM = pinVM
        cell.pinContentVC = cellVC
        return cell
    }
}

// MARK:- Transition Stuff



extension AHDetailVC: AHTransitionPushFromDelegate {
    func transitionPushFromSelectedCell() -> AHPinCell? {
        return self.selectedCell
    }
    
}

extension AHDetailVC: AHTransitionPushToDelegate {

    func transitionPushToPresentingCell() -> AHPinContentCell? {
        return self.presentingCell
    }

}

extension AHDetailVC: AHTransitionPopFromDelegate {
    func transitionPopToSelectedCell() -> AHPinCell? {
        return self.selectedCell
    }
}

extension AHDetailVC: AHTransitionPopToDelegate {
    func transitionPopFromPresentingCell() -> AHPinContentCell? {
        return self.presentingCell
    }
}


extension AHDetailVC {
    func calculateImageHeight(imageSize: CGSize, newWidth: CGFloat) -> CGFloat {
        let newHeight = newWidth * imageSize.height / imageSize.width
        return newHeight
    }
}

