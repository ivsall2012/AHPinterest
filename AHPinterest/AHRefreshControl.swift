//
//  AHRefreshControl.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/11/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHRefreshControl: NSObject {
    var headerCell: AHRefreshHeader?{
        didSet {
            if let headerCell = headerCell {
                headerCell.isHidden = true
            }
        }
    }
    var footerCell: AHRefreshFooter?{
        didSet {
            if let footerCell = footerCell {
                footerCell.isHidden = true
            }
        }
    }
    weak var pinVC: AHPinVC?
    weak var layoutRouter: AHLayoutRouter?
    var isLoading = false
}

extension AHRefreshControl {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layoutRouter = layoutRouter else {
            return
        }
        if layoutRouter.enableHeaderRefresh {
            handlerPullToRefresh(scrollView, didEndDragging: false)
        }
        if layoutRouter.enableFooterRefresh {
            handleAutoLoading(scrollView, didEndDragging: false)
        }
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let layoutRouter = layoutRouter else {
            return
        }
        if layoutRouter.enableHeaderRefresh {
            handlerPullToRefresh(scrollView, didEndDragging: true)
        }
        if layoutRouter.enableFooterRefresh {
            handleAutoLoading(scrollView, didEndDragging: true)
        }
    }
}

// MARK:- Auto loading for old pins
extension AHRefreshControl {
    func handleAutoLoading(_ scrollView: UIScrollView, didEndDragging: Bool) {
        let contentSize = scrollView.contentSize
        let yOffset = scrollView.contentOffset.y
        
        let screenHeight = UIScreen.main.bounds.height
        // yOffset + screenHeight is the current bottom y position
        // deltaLeft represents how long it's left to scroll
        let deltaLeft = contentSize.height - (yOffset + screenHeight)
        
// the following confition will be satisfied first since scrollView reaches the bottom first. And we do networking first too before the user sees footerCell refreshes.
        if yOffset > 0.0 &&  deltaLeft > 0.0 {
            // we load older pins when there's only one screen height left to scroll
            if deltaLeft < screenHeight * 2{
                // at this point, the footerCell has not being dequeued from collectionView yet. Thus self.footerCell is nil
                if !isLoading {
                    // isLoading = true as an indicator for footerCell?.refresh() later
                    isLoading = true
                    pinVC?.loadOlderData(completion: { (_) in
                        self.isLoading = false
//                        self.footerCell?.endRefersh()
                    })
                }
            }
        }
        
// the following condition will be called if the scrolling is really fast cuasing collectionView being pulled up. Then the refreshControl will be shown here
// deltaLeft being negative means the user is pulling up, no positive space left to scroll, but negative one
        if deltaLeft <= -AHCollectionViewInset.bottom {
            if isLoading {
                // this block can be called mutiple times as user keeps pulling up
                // but it's ok since footerCell?.refresh() only responses the first call
                footerCell?.refresh()
            }
        }
        
        
    }
}




// MARK:- Pull-to-Refresh stuff
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
                        self.pinVC?.loadNewData(completion: { (_) in
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
    func showingRefreshControl(yOffset: CGFloat, headerCell: AHRefreshHeader) {
        guard yOffset >= 0.0 else {
            return
        }
        let ratio = yOffset / headerCell.bounds.height * 0.5
        if ratio <= 1.0 {
            headerCell.pulling(ratio: ratio)
        }
    }
    
}


