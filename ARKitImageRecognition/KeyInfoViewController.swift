//
//  KeyInfoViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/7.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class KeyInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var KType: String = ""
    var KInfo: KeyInfo? = KeyInfo()
    
    @IBOutlet var isFloorChoose: UISegmentedControl!
    @IBOutlet weak var keyImage: UIImageView!
    @IBOutlet var pickingPhotoButton: UIButton!
    @IBOutlet var clue: UITextField!
    @IBOutlet var hint: UITextField!
    
    
    @IBAction func saveBack(_ sender: UIButton) {
        print("yaHaaaaa~~")
        
        // TODO: make sure that nothing is nil~
        
        KInfo?.keyImg.isFloor = (isFloorChoose.selectedSegmentIndex == 0)
        KInfo?.keyClue = clue.text!
        KInfo?.keyHint = hint.text!
        print("befor perfromSegue")
        self.performSegue(withIdentifier: "goEditMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEdittingWord()
        setBgImg()
        KInfo?.keyImg = ImageInfo()
        // Do any additional setup after loading the view.
    }
    
    func setEdittingWord(){
        self.title = KType + "鑰匙設定"
        self.pickingPhotoButton.setTitle("加入" + KType + "鑰匙位置照片", for: .normal)
    }
    func setBgImg(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "editorbackground.png")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        backgroundImage.alpha = 0.5
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pickPhoto(_ sender: UIButton) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        let uniqueString = NSUUID().uuidString
        
        if let selectedImage = selectedImageFromPicker {
            self.KInfo?.keyImg.image = selectedImageFromPicker
            DispatchQueue.main.async {
                self.keyImage.image = selectedImage
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

}
