//
//  Constants.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/9/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

let AHNumberOfColumns: Int = 2
let AHCellPadding : CGFloat = 8.0
let AHNoteFont: UIFont = UIFont.boldSystemFont(ofSize: 15.0)
let AHUserAvatarHeight: CGFloat = 50.0

let AHPinCellIdentifier = "AHPinCell"
let AHPinContentCellIdentifier = "AHPinContentCell"

// Header and Footer are the total height, not their subviews' sizes, i.e. AHRefreshHeader and AHRefreshFooterSize
let AHHeaderKind: String = "AHHeaderKind"
let AHFooterKind: String = "AHFooterKind"


let AHHeaderHeight: CGFloat = 80
let AHFooterHeight: CGFloat = 50

// Header and Footer's coorsponding subviews -- the refresh views for animations
let AHRefreshHeaderSize: CGSize = CGSize(width: 40, height: 40)
let AHRefreshFooterSize: CGSize = CGSize(width: 40, height: 40)

// Refresh is triggerd by pulling down 70% or more of AHHeaderHeight
let AHHeaderShouldRefreshRatio: CGFloat = 0.7


// The collectionView within AHPinVC
let AHCollectionViewInset: UIEdgeInsets = UIEdgeInsets(top: 23, left: 5, bottom: AHFooterHeight + 8, right: 5)
