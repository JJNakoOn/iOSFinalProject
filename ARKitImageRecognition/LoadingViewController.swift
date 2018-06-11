//
//  LoadingViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/11.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet var loadingImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadingImageView.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.loadingImageView.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {
            self.loadingImageView.alpha = 0
        }, completion: { finished in
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
