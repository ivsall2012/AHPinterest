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
        handlerPullToRefresh(scrollView, didEndDragging: false)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        handlerPullToRefresh(scrollView, didEndDragging: true)
        
    }
}


// MARK:- For Pull-to-Refresh stuff
extension AHRefreshControl {
    func handlerPullToRefresh(_ scrollView: UIScrollView, didEndDragging: Bool) {
        guard let headerCell = headerCell else {
            return
        }
        // if the refreshControl is spinning then return
        guard !headerCell.isSpinning else {
            return
        }
        if didEndDragging {
            // user lifted their touch, now check if refresh should be triggered or not
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
        }else{
            // user is still dragging
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
    }
    /// tell the header cell how much to pull down
    func showingRefreshControl(yOffset: CGFloat, headerCell: AHCollectionRefreshHeader) {
        guard yOffset >= 0.0 else {
            return
        }
        let ratio = yOffset / headerCell.bounds.height * 0.5
        if ratio <= 1.0 {
            headerCell.pulling(ratio: ratio)
        }
    }
    
}


