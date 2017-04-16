//
//  AHCardDataGenerator.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

public class AHPinDataGenerator: NSObject {
    static let generator =  AHPinDataGenerator()
    let randomPicURL = "http://lorempixel.com/400/200"
    let randomPicHolder = "http://placehold.it/350x150"
    let anotherPlaceHolder = "https://placeimg.com/640/480/any"
    
    let paragraph = "Lorem ipsum"
    
    let userAvatars = ["https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-1.png?alt=media&token=c197a8dc-6176-4af8-98b5-0658a5e0846a",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-2.jpg?alt=media&token=6beea959-af9b-408f-8aed-b5431af943d3",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-2.png?alt=media&token=2bdbc9f6-86de-4899-a5d7-120c960d1c68",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-3.png?alt=media&token=1778371e-d11e-4b62-8123-8390ba7f478a",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-4.jpg?alt=media&token=9668430f-b33f-4f11-8e62-f4505bf1757b",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-100-done.png?alt=media&token=ba219d2b-dc99-4b4d-a661-201e3ce41a60",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-102-done.png?alt=media&token=0acb9659-4c19-49f7-a9d3-cc7ea595a4e4",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-101-done.png?alt=media&token=f2ca4770-47b4-45f5-9765-d5fbfd2b558a",
    "https://firebasestorage.googleapis.com/v0/b/localfun-c9f46.appspot.com/o/internal-user-icons%2Fuser-icon-103-done.png?alt=media&token=afad647c-b482-41b6-9cd7-441c5c1f958d"]

    
    
    
}


extension AHPinDataGenerator{
    func randomData() -> [AHPinViewModel] {
        let pinModels = randomCardBatch()
        var viewModelArr = [AHPinViewModel]()
        for pinModel in pinModels {
            let viewModel = AHPinViewModel(pinModel: pinModel)
            viewModelArr.append(viewModel)
        }
        return viewModelArr
    }
    
    
    func randomCardBatch() -> [AHPinDataModel] {
        var data = [AHPinDataModel]()
        for _ in 0..<20 {
            let dict = randomPin()
            if let pinData = AHPinDataModel(dict: dict) {
                data.append(pinData)
            }
            
        }
        
//        let dicts = generatePinArr(specific: [400.0, 50.0, 100.0, 50.0])
//        for dict in dicts {
//            if let pinData = PinDataModel(dict: dict) {
//                data.append(pinData)
//            }
//        }
        
        
        return data
    }
    
    
    func randomPin() -> [String: Any]{
        var dict = [String: Any]()
        
        let smalText = random(0, 3)
        let bigText = random(3, 5)
        // it has 60% chance to have smal text
        let manyWords = randomPercentChance(percent: 60) ? smalText : bigText
        var note: String = ""
        for _ in 0..<manyWords {
            note.append(paragraph)
        }
        dict["note"] = note
        
        
        
        let width = 100 * random(1, 2)
        let height = 100 * random(1, 2)
        let imageUrlA = "http://lorempixel.com/\(width)/\(height)"
        let imageUrlC = "https://placeimg.com/\(width)/\(height)/any"
        let images = [imageUrlA,imageUrlC]
        let imageUrl = images[random(images.count)]
        dict["imageSize"] = ["width": CGFloat(width), "height": CGFloat(height)]
        dict["imageURL"] = imageUrl
        
        
        let name = randomName(with: "The Generator")
        dict["userName"] = name
        
        let userAvatar = userAvatars[random(userAvatars.count)]
        dict["avatarURL"] = userAvatar
        
        
        
        return dict
        
    }
    
    func generatePinArr(specific heights: [NSNumber]) -> [[String: Any]] {
        var arr = [[String: Any]]()
        for height in heights {
            let pinDict = generatePin(specific: height)
            arr.append(pinDict)
        }
        return arr
    }
    
    
    func generatePin(specific height: NSNumber) -> [String: Any] {
        var dict = [String: Any]()
        
        let smalText = random(1, 3)
        let bigText = random(3, 5)
        // it has 60% chance to have smal text
        let manyWords = randomPercentChance(percent: 60) ? smalText : bigText
        var note: String = ""
        for _ in 0..<manyWords {
            note.append(paragraph)
        }
        dict["note"] = note
        
        
        
        let width = 100 * random(1, 3)
        let height = height
        let imageUrlA = "http://lorempixel.com/\(width)/\(height)"
        let imageUrlC = "https://placeimg.com/\(width)/\(height)/any"
        let images = [imageUrlA,imageUrlC]
        let imageUrl = images[random(images.count)]
        dict["imageSize"] = ["width": CGFloat(width), "height": height]
        dict["imageURL"] = imageUrl
        
        
        let name = randomName(with: "The Generator")
        dict["userName"] = name
        
        let userAvatar = userAvatars[random(userAvatars.count)]
        dict["avatarURL"] = userAvatar

        
        return dict
    }
    
}




//MARK:- For random helper
extension AHPinDataGenerator {
    
    func randomName(with prefix: String) -> String {
        let num = random(999)
        return "\(prefix) \(num) "
    }
    
    func randomPercentChance(percent: Int) -> Bool {
        let randomNum = random(100)
        if randomNum < percent {
            return true
        }else{
            return false
        }
    }
    
    func randomBool() -> Bool {
        let rand = arc4random_uniform(100)
        return rand % 2 == 0 ? true : false
    }
    
    func random(_ ceil: Int) -> Int {
        return Int(arc4random_uniform(UInt32(ceil)))
    }
    
    func random(_ floor: Int, _ ceil: Int) -> Int {
        guard floor < ceil else {
            return -1
        }
        return Int(arc4random_uniform(UInt32(ceil - floor))) + floor
    }
}








