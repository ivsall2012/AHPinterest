//
//  AHCategoryDataModel.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/29/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHCategoryDataModel: NSObject {
    var coverURL: String
    var isTrending: Bool
    var categoryName: String
    var imageSize: CGSize
    var isFullWidth: Bool
    init(data: [String: Any]) {
        self.coverURL = data["imageURL"] as! String
        self.isTrending = data["isTrending"] as! Bool
        self.categoryName = data["categoryName"] as! String
        self.isFullWidth = data["isFullWidth"] as! Bool
        
        var imageSize: CGSize = .zero
        if let imageSizeDict = data["imageSize"] as? [String: CGFloat] {
            if let imageW = imageSizeDict["width"], let imageH = imageSizeDict["height"] {
                imageSize = CGSize(width: imageW, height: imageH)
            }
        }
        self.imageSize = imageSize
    }
}
