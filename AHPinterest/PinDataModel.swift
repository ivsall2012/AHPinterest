//
//  Photo.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class PinDataModel : NSObject {
    
    
    var imageSize: CGSize
    var imageURL: String
    var note: String
    var userName: String
    var avatarURL: String
    init(note: String, userName: String, avatarURL: String, imageURL: String ,imageSize: CGSize) {
        self.imageSize = imageSize
        self.imageURL = imageURL
        self.note = note
        self.userName = userName
        self.avatarURL = avatarURL
    }
    
    convenience init?(dict: [String: Any]) {
        guard let note = dict["note"] as? String,
        let imageURL = dict["imageURL"] as? String,
        let userName = dict["userName"] as? String,
        let avatarURL = dict["avatarURL"] as? String else {
                print("data dict:\(dict) is not complete")
                return nil
        }
        
        var imageSize: CGSize = .zero
        if let imageSizeDict = dict["imageSize"] as? [String: CGFloat] {
            if let imageW = imageSizeDict["width"], let imageH = imageSizeDict["height"] {
                imageSize = CGSize(width: imageW, height: imageH)
            }
        }
        
        self.init(note: note, userName: userName, avatarURL: avatarURL, imageURL: imageURL ,imageSize: imageSize)
        
        
        
    }
}
