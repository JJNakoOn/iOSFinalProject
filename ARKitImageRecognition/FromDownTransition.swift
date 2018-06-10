//
//  FromDownTransition.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/10.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class FromDownTransition: UIStoryboardSegue {
    override func perform() {
        // 指定來源與目標視圖給區域變數
        var firstVCView = self.source.view as UIView!
        var secondVCView = self.destination.view as UIView!
        
        // 取得畫面寬度及高度
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // 指定目標視圖的初始位置
        secondVCView?.frame = CGRect(0.0, screenHeight, screenWidth, screenHeight)
        
        // 存取App的 key window 並插入目標視圖至目前視圖（來源視圖）上
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
        
        // 轉換動畫
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, -screenHeight)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, -screenHeight)
            
        }) { (Finished) -> Void in
            self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
                                                            animated: false,
                                                            completion: nil)
        }
        
    }
}
