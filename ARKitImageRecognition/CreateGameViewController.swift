//
//  CreateGameViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/7.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var gameTitle: UITextField!
    @IBOutlet var gameIntroduction: UITextField!
    @IBOutlet var boxPos: UITextField!
    @IBOutlet var winMsg: UITextField!
    var info: GameInfo? = GameInfo()
    @IBOutlet weak var boxImage: UIImageView!
    @IBOutlet var boxImgIsFloor: UISegmentedControl!
    @IBAction func pickBoxPhoto(_ sender: UIButton) {
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    @IBAction func upLoadData(_ sender: UIButton) {
        
        // make sure that nothing is nil
        
        info?.gameName = gameTitle.text!
        info?.introduction = gameIntroduction.text!
        info?.boxPos = boxPos.text!
        info?.winMessage = winMsg.text!
        info?.boxImg?.isFloor = (boxImgIsFloor.selectedSegmentIndex == 0)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBgImg()
        info?.boxImg = ImageInfo()
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
        }
        let uniqueString = NSUUID().uuidString
        if let selectedImage = selectedImageFromPicker {
            self.info?.boxImg?.image = selectedImageFromPicker!
            DispatchQueue.main.async {
                self.boxImage.image = selectedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editGold" {
            self.prepareEditingKey(for: segue, type: keyType.gold.rawValue)
        } else if segue.identifier == "editSilver" {
            self.prepareEditingKey(for: segue, type: keyType.silver.rawValue)
        } else if segue.identifier == "editCopper" {
            self.prepareEditingKey(for: segue, type: keyType.copper.rawValue)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func prepareEditingKey(for segue: UIStoryboardSegue, type: String) {
        let keyInfoViewController = segue.destination as! KeyInfoViewController
        keyInfoViewController.KType = type
    }

    @IBAction func saveUnwindSegueFromKeyInfoView(_ segue: UIStoryboardSegue){
        guard let keyInfo = segue.source as? KeyInfoViewController else {return}
        switch keyInfo.KType {
            case keyType.gold.rawValue:
                self.info?.goldKeyInfo = keyInfo.KInfo
            case keyType.silver.rawValue:
                self.info?.silverKeyInfo = keyInfo.KInfo
            case keyType.copper.rawValue:
                self.info?.copperKeyInfo = keyInfo.KInfo
            default:
            fatalError("Wrong things happened!")
        }
    }
}

