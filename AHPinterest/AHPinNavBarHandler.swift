//
//  AHPinNavBarDelegate.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/19/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPinNavBarHandler: NSObject {
    weak var navBar: AHPinNavBar?
    weak var contentVC: AHPinContentVC?
    var triggeredYposition: CGFloat {
        guard let contentVC = contentVC else {
            return -9999.0
        }
        let section = contentVC.pinLayout.layoutSection
        if section < contentVC.layoutRouter.sectionYorigins.count {
            return contentVC.layoutRouter.sectionYorigins[section]
        }
        
        return -9999.0
    }
}

extension AHPinNavBarHandler: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= triggeredYposition {
            navBar?.showNavBar = false
        }else{
            navBar?.showNavBar = true
        }
    }
}
