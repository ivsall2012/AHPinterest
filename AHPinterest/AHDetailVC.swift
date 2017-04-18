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
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    func createPinVC() -> AHPinVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHPinVC") as! AHPinVC
        
        // setup layout
        let pinDetailLayout = AHPinDetailLayout()
        let pinDetailLayoutHanlder = AHPinDetailLayoutHandler()
        pinDetailLayout.delegate = pinDetailLayoutHanlder
        vc.addLayout(layout: pinDetailLayout, delegate: pinDetailLayoutHanlder, dataSource: pinDetailLayoutHanlder)
        
        // setup VC related
        vc.willMove(toParentViewController: self)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        // other stuff
        vc.refreshLayout.enableFooterRefresh = true
        vc.refreshLayout.enableHeaderRefresh = false
        
        return vc
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







