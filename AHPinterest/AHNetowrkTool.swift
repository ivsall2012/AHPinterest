//
//  AHNetowrkTool.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

let shouldCacheImage = true

class AHNetowrkTool: NSObject {
    static let tool = AHNetowrkTool()
    
    var imageCache = [String: UIImage]()
    
    
}

// MARK:- Pin Data Related
extension AHNetowrkTool {
    func loadNewData(completion: @escaping ([PinViewModel]) -> Swift.Void) {
        // fake networking:)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let arr = AHPinDataGenerator.generator.randomData()
            completion(arr)
        }
    }
}


// MARK:- Image Related
extension AHNetowrkTool {
    func requestImage(urlStr: String, completion: @escaping (_ image: UIImage?) -> Swift.Void) {
        guard let url = URL(string: urlStr) else {
            return
        }
        if let cachedImg = imageCache[url.absoluteString] {
            completion(cachedImg)
        }else{
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                DispatchQueue.main.async {
                    if let data = data, error == nil {
                        if let image = UIImage(data: data) {
                            self.imageCache[url.absoluteString] = image
                            completion(image)
                            return
                        }
                        
                    }
                    completion(nil)
                }
            }
            DispatchQueue.global().async {
                task.resume()
            }
            
        }
    }
}
