//
//  AHDiscoverNavHandler.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/27/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

private let AHDiscoverNavCellID = "AHDiscoverNavCell"

class AHDiscoverNavHandler: NSObject {
    var categoryArr = [String]()
    let initialIndexPath = IndexPath(item: 0, section: 0)
    weak var discoverNavVC: AHDiscoverNavVC! {
        didSet {
            self.background.isHidden = true
        }
    }
    lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = AHDiscoverNavCellHeight * 0.5
        return view
    }()
    
    func reload() {
        AHNetowrkTool.tool.reloadCategories { (categoryArr: [String]) -> () in
            self.categoryArr.append(contentsOf: categoryArr)
            self.discoverNavVC.collectionView?.reloadData()
        }
    }
}

extension AHDiscoverNavHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryStr = self.categoryArr[indexPath.item]
        let font = UIFont.systemFont(ofSize: AHDiscoverNavCellFontSize)
        let size = CGSize(width: CGFloat(DBL_MAX), height: AHDiscoverNavCellHeight)
        let rect =  (categoryStr as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        let width = ceil(rect.width)
        return CGSize(width: width + 2 * AHDiscoverNavCellPadding, height: AHDiscoverNavCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: AHDiscoverNavCellPadding, height: AHDiscoverNavCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: AHDiscoverNavCellPadding, height: AHDiscoverNavCellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        scrollToItem(at: indexPath, collectionView: collectionView)
        return true
    }

    func scrollToItem(at indexPath:IndexPath, collectionView: UICollectionView) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AHDiscoverNavCell else {
            return
        }
        
        let bgFrame = cell.convert(cell.categoryLabel.frame, to: collectionView)
        background.isHidden = false
        collectionView.insertSubview(background, belowSubview: cell)
        
        UIView.animate(withDuration: 0.25) { 
            self.background.frame = bgFrame.insetBy(dx: 0.0, dy: 8)
            self.background.layer.cornerRadius = self.background.frame.size.height * 0.5
        }
        
        
        let center = cell.convert(cell.categoryLabel.center, to: collectionView)
        let totalWidth = collectionView.frame.size.width
        
        // only those lay on the right half of the screen, need to be centerd
        if center.x > totalWidth * 0.5 {
            if center.x < collectionView.contentSize.width - totalWidth * 0.5 {
                // scroll as long as it doesn't make collectionView go off its contentSize
                let offset = CGPoint(x: center.x - totalWidth * 0.5, y: 0.0)
                collectionView.setContentOffset(offset, animated: true)
            }else{
                // scroll to default position
                collectionView.setContentOffset(CGPoint(x: collectionView.contentSize.width - totalWidth, y:0), animated: true)
            }
        }else{
            // scroll to default position
            collectionView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        }
        
    }
    
}

extension AHDiscoverNavHandler: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AHDiscoverNavCellID, for: indexPath) as! AHDiscoverNavCell
        
        let categoryStr = categoryArr[indexPath.item]
        cell.categoryLabel.text = categoryStr
        if !categoryArr.isEmpty && indexPath.item == 0 {
            // by unblocking this method cellForItemAt, the cell will be returned and then we scrollToItem
            DispatchQueue.main.async {
                self.scrollToItem(at: self.initialIndexPath, collectionView: collectionView)
            }
        }
        
        return cell
    }

    
}






