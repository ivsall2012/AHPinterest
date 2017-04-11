//
//  AHRefreshControl.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/11/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHRefreshControl: NSObject {
    weak var headerCell: AHCollectionRefreshHeader?
    weak var viewModel: ViewModel?
    
}

extension AHRefreshControl {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerCell = headerCell else {
            return
        }
        guard !headerCell.isSpinning else {
            return
        }
        
        let yOffset = scrollView.contentOffset.y
        let topInset = scrollView.contentInset.top
        // the following extra -10 is to make the refreshControl hide "faster"
        if yOffset < -topInset - 10 {
            headerCell.isHidden = false
            showingRefreshControl(yOffset: abs(yOffset), headerCell: headerCell)
        }else{
            headerCell.isHidden = true
        }
    }
    func showingRefreshControl(yOffset: CGFloat, headerCell: AHCollectionRefreshHeader) {
        guard yOffset >= 0.0 else {
            return
        }
        let ratio = yOffset / headerCell.bounds.height * 0.5
        if ratio <= 1.0 {
            headerCell.pulling(ratio: ratio)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let headerCell = headerCell else {
            return
        }
        guard !headerCell.isSpinning else {
            return
        }
        if headerCell.ratio >= AHHeaderShouldRefreshRatio {
            headerCell.refresh()
            UIView.animate(withDuration: 0.25, animations: {
                scrollView.contentInset.top = headerCell.bounds.height
                }, completion: { (_) in
                    self.viewModel?.loadNewData(completion: { (_) in
                        UIView.animate(withDuration: 0.25, animations: { 
                            scrollView.contentInset = AHCollectionViewInset
                        })
                    })

            })
        }
        
    }
}
