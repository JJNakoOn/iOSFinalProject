//
//  DetailClueViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/12.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class DetailClueViewController: UIViewController {

    
    @IBOutlet var clue: UILabel!
    @IBOutlet var hintTitle: UILabel!
    @IBOutlet var hint: UILabel!
    @IBOutlet var finalHintImg: UIImageView!
    @IBOutlet var finalHintImgVertical: UIImageView!
    @IBOutlet var hideWhenImaging: UILabel!
    @IBAction func cash(_ sender: UIBarButtonItem) {
        if(keyInfo.keyHint.isEmpty){ // box view
            if cashingCount > 0{
                showAlert()
            } else {
                showCashingWindow()
            }
        } else {
            if cashingCount > 1{
                showAlert()
            } else {
                showCashingWindow()
            }
        }
    }
    
    var keyInfo: KeyInfo = KeyInfo()
    var cashingCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(keyInfo.keyHint.isEmpty){
            hintTitle.isHidden = true
            hint.isHidden = true
        } else {
            hintTitle.isHidden = false
            hint.isHidden = false
        }
        setBgImg()
        self.resetWordSetting()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setBgImg(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "editorbackground.png")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        backgroundImage.alpha = 0.5
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func resetWordSetting(){
        clue.text = keyInfo.keyClue
        if(cashingCount > 0 ){
            if(keyInfo.keyHint.isEmpty){ // box information
                showImage()
            }else if(cashingCount == 1){
                showHint()
            }else{
                showHint()
                showImage()
            }
        }
    }
    
    func showImage(){
        hideWhenImaging.isHidden = true
        var tempImg: UIImage = UIImage()
        let emptyImg: UIImage = UIImage()
        switch self.title {
            case "寶箱資訊":
                tempImg = getSavedImage(named:"treasureBox.jpg")!
            case "金鑰匙資訊":
                tempImg = getSavedImage(named:"goldKey.jpg")!
            case "銀鑰匙資訊":
                tempImg = getSavedImage(named:"silverKey.jpg")!
            case "銅鑰匙資訊":
                tempImg = getSavedImage(named:"copperKey.jpg")!
            default:
                print("ERROR when showing IMAGE")
                return
        }
        if(tempImg.size.width > tempImg.size.height){
            finalHintImg.image = tempImg
            finalHintImgVertical.image = emptyImg
        } else {
            finalHintImg.image = emptyImg
            finalHintImgVertical.image = tempImg
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    func showHint(){
        hint.text = keyInfo.keyHint
    }
    func showAlert(){
        let alert = UIAlertController(title: "錯誤", message: "無法再獲得更多提示", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showCashingWindow(){
        let alertController = UIAlertController(title: "課金提醒！",
                                                message: "您即將消費NT$0,確認消費?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            self.cashingCount += 1
            self.resetWordSetting()
            self.showCashingSuccess()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func showCashingSuccess(){
        let alert = UIAlertController(title: "課金成功！", message: "祝您遊戲愉快", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }


}
