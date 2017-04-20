//
//  AHPinContentStickyHeader.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/19/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHDetailNavBar: UICollectionReusableView {
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var optionContainer: UIView!

    var showNavBar = true {
        didSet {
            if showNavBar {
                self.optionContainer.isHidden = false
                self.moreLabel.isHidden = true
            }else{
                self.optionContainer.isHidden = true
                self.moreLabel.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }

    class func navBar() -> AHDetailNavBar {
        return Bundle.main.loadNibNamed("AHDetailNavBar", owner: self, options: nil)!.first as! AHDetailNavBar
    }
    
    @IBAction func saveBtnTapped(_ sender: AnyObject) {
    }
    
    @IBAction func moreBtnTapped(_ sender: AnyObject) {
    }
    @IBAction func planeBtnTapped(_ sender: AnyObject) {
    }
    @IBAction func checkBtnTapped(_ sender: UIButton) {
    }
    @IBAction func backBtnTapped(_ sender: AnyObject) {
    }
    
}
