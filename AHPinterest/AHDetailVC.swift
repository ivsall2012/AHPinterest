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

    var pinVMs: [AHPinViewModel]?
    var currentIndexPath: IndexPath?
    fileprivate var cellVCs = [AHPinContentVC]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        collectionView?.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView?.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)

        let layout = AHDetailVCLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.reloadData()
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        layout.scrollDirection = .horizontal
        
        guard let pinVMs = pinVMs else {
            return
        }
        
        for _ in pinVMs {
            let vc = createPinVC()
            cellVCs.append(vc)
        }
        self.view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        currentIndexPath?.section = 0
        collectionView.scrollToItem(at: currentIndexPath!, at: UICollectionViewScrollPosition.right, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        
    }
    
   
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        print("saved photo")
    }

}

// MARK:- Helper Methods
extension AHDetailVC {
    func createPinVC() -> AHPinContentVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHPinContentVC") as! AHPinContentVC
        vc.showContentPin = true
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
        }else{
            print("visible items have more then 1, problem?!")
        }
    }
}


extension AHDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height - (collectionView.contentInset.top + collectionView.contentInset.bottom))
        return CGSize(width: size.width, height: screenSize.height - 20)
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







