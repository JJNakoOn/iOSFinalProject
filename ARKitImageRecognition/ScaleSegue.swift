//
//  ScaleSegue.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/11.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {

    override func perform() {
        scale()
    }
    func scale(){
        let toVC = self.destination
        let fromVC = self.source
        let containerView = fromVC.view.superview
        let originalCenter = toVC.view.center
        
        toVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toVC.view.center = originalCenter
        
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toVC.view.transform = CGAffineTransform.identity
        }) { (success) in
            fromVC.present(toVC, animated: false, completion: nil)
        }
    }
}
