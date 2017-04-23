//
//  AHPublicObjects.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/23/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPublicObjects: NSObject {
    static let shared = AHPublicObjects()
    weak var navigatonController: AHNavigationController?
}
