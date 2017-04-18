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
    fileprivate var cellVCs = [AHPinVC]()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pinVMs = pinVMs else {
            return
        }
        
        for _ in pinVMs {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AHPinVC") as! AHPinVC
            let pinContentLayout = AHPinContentLayout()
            let contentHanlder = AHPinContentHandler()
            pinContentLayout.delegate = contentHanlder
            vc.addLayout(layout: pinContentLayout, delegate: contentHanlder, dataSource: contentHanlder)
            vc.refreshLayout.enableFooterRefresh = true
            vc.refreshLayout.enableHeaderRefresh = false
            vc.willMove(toParentViewController: self)
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            cellVCs.append(vc)
        }
        let layout = AHDetailLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.reloadData()
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        layout.scrollDirection = .horizontal
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // You need to call this before "scrollToItem" in order for collection view to layout its item cells, then scroll.
        self.view.layoutIfNeeded()
        
        if let currentIndexPath = currentIndexPath , pinVMs != nil {
            collectionView.scrollToItem(at: currentIndexPath, at: UICollectionViewScrollPosition.right, animated: false)
        }
    }
    
    
    class func calculateImageSize(image: UIImage) -> CGRect {
        let imgSize = image.size
        let newWidth = screenSize.width - 2 * AHDetailCellMargin
        let newHeight = newWidth * imgSize.height / imgSize.width
        let newX : CGFloat = AHDetailCellMargin
        var newY: CGFloat
        if newHeight > screenSize.height {
            // log photo
            newY = 0.0
        }else{
            // photo can fit in the screen
            newY = (screenSize.height - newHeight) * 0.5
        }
        let newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        return newFrame
    }
    

    
    @IBAction func nextBtnTapped(_ sender: AnyObject) {
//        let indexPath = IndexPath(item: 2, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: false)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        print("saved photo")
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
        // collectionView's frame and bounds are not accurate
        return screenSize
    }
    
}

extension AHDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let pinVMs = pinVMs else {
            return 0
        }
        print("pinVMs.count:\(pinVMs.count)")
        return pinVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AHDetailCell
        
        guard let pinVMs = pinVMs else {
            return cell
        }
        let cellVC = cellVCs[indexPath.item]    
        cell.pinVC = cellVC
        return cell
    }
}







