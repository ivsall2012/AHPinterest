//
//  AHPinterestTests.swift
//  AHPinterestTests
//
//  Created by Andy Hurricane on 3/26/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import XCTest
@testable import AHPinterest
class AHPinterestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPhotos() {
        let arr = Photo.allPhotos()
        XCTAssertEqual(arr.count, 13)
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
