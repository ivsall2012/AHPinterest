//
//  AHPopInteractiveTransition.swift
//  AHPinterest
//
//  Created by Andy Hurricane on 4/25/17.
//  Copyright © 2017 AndyHurricane. All rights reserved.
//

import UIKit

class AHPopInteractiveTransition: UIPercentDrivenInteractiveTransition {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(panHanlder(_:)))

}

extension AHPopInteractiveTransition {
    func attachView(view: UIView) {
        
    }
    
    func panHanlder(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            print("began")
        case .changed:
            print("changed")
        case .cancelled, .ended:
            print("ended")
        default:
            break
        }
    }
}
