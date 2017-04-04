//
//  Photo.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class Photo : NSObject {
    
    class func allPhotos() ->[Photo] {
        var photos = [Photo]()
        if let url = Bundle.main.path(forResource: "Photos", ofType: "plist"){
            if let arr = NSArray(contentsOfFile: url){
                for dict in arr {
                    let photo = Photo(dict: (dict as! [String : String]))
                    photos.append(photo)
                }
            }
            
        }
        return photos
        
        
    }
    
    
    
    var image: UIImage?
    var caption: String?
    var comment: String?
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    convenience init(dict: [String: String]) {
        let caption = dict["Caption"]
        let comment = dict["Comment"]
        let imageStr = dict["Photo"]
        let image = UIImage(named: imageStr!)?.decompressdImage
        self.init(caption: caption!, comment: comment!, image: image!)
    }
    
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat{
        guard comment != nil else {
            return 0.0
        }
        
        let size = CGSize(width: width, height: CGFloat(DBL_MAX))
        let rect =  (comment! as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
