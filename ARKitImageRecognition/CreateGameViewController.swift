//
//  CreateGameViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/7.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class CreateGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet var gameTitle: UITextField!
    @IBOutlet var gameIntroduction: UITextField!
    @IBOutlet var boxPos: UITextField!
    @IBOutlet var winMsg: UITextField!
    var info: GameInfo? = GameInfo()
    var imgSelected:Bool = false
    @IBOutlet weak var boxImage: UIImageView!
    @IBOutlet weak var boxImageVertical: UIImageView!
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
        /*
        info?.gameName = gameTitle.text!
        info?.introduction = gameIntroduction.text!
        info?.boxPos = boxPos.text!
        info?.winMessage = winMsg.text!
        info?.boxImg?.isFloor = (boxImgIsFloor.selectedSegmentIndex == 0)
        print("Get upLoad information!")
         */
        
        
        self.performSegue(withIdentifier: "uploadSegue", sender: self)
        
        /*
        // Start uploading
        let uniqueString = NSUUID().uuidString
        uploadImage(title: (info?.gameName)!, image: (info?.boxImg.image)!, name: "box", us: uniqueString)
        uploadImage(title: (info?.gameName)!, image: (info?.goldKeyInfo.keyImg.image)!, name: "goldKey", us: uniqueString)
        uploadImage(title: (info?.gameName)!, image: (info?.silverKeyInfo.keyImg.image)!, name: "silverKey", us: uniqueString)
        uploadImage(title: (info?.gameName)!, image: (info?.copperKeyInfo.keyImg.image)!, name: "copperKey", us: uniqueString)
        setDatabaseInfo(us: uniqueString)
        */
    }
    
    func uploadImage(title: String, image: UIImage, name: String, us: String) {
        
        // upload the box Image
        let storageRef = Storage.storage().reference().child(title).child("\(name).jpg")
        
        if let ImageData = UIImageJPEGRepresentation(image, 0.4){
            //storage save
            let uploadTask = storageRef.putData(ImageData, metadata: nil){ (metadata, error) in
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                storageRef.downloadURL { (imageUrl, error) in
                    if error != nil {
                        print("get url error")
                        // Handle any errors
                    } else {
                        // Get the download URＬ
                        let uploadImageUrl = imageUrl?.absoluteString
                        print("Photo Url: \(uploadImageUrl)")
                        
                        if(name == "box"){
                            let databaseRef = Database.database().reference().child(us).child("boxImgInfo").child("data")
                            databaseRef.setValue(uploadImageUrl!, withCompletionBlock: { (error, dataRef) in
                                if error != nil {
                                    print("Database Error: \(error!.localizedDescription)")
                                }
                                else {
                                    print("Url of \(name) is in the database")
                                }
                            })
                        }
                        else{
                            let databaseRef = Database.database().reference().child(us).child("keys").child(name).child("keyImgInfo").child("data")
                            databaseRef.setValue(uploadImageUrl!, withCompletionBlock: { (error, dataRef) in
                                if error != nil {
                                    print("Database Error: \(error!.localizedDescription)")
                                }
                                else {
                                    print("Url of \(name) is in the database")
                                }
                            })
                        }
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func setDatabaseInfo(us: String){
        
        var databaseRef = Database.database().reference().child(us).child("name")
        databaseRef.setValue(info?.gameName, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        
        databaseRef = Database.database().reference().child(us).child("introduction")
        databaseRef.setValue(info?.introduction, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        
        databaseRef = Database.database().reference().child(us).child("boxPos")
        databaseRef.setValue(info?.boxPos, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        
        databaseRef = Database.database().reference().child(us).child("boxImgInfo").child("isFloor")
        databaseRef.setValue(info?.boxImg.isFloor, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        
        databaseRef = Database.database().reference().child(us).child("winMsg")
        databaseRef.setValue(info?.winMessage, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        setKeyDBInfo(us: us, keyName: "goldKey", clue: (info?.goldKeyInfo.keyClue)!, hint: (info?.goldKeyInfo.keyHint)!, isFloor: (info?.goldKeyInfo.keyImg.isFloor)!)
        setKeyDBInfo(us: us, keyName: "silverKey", clue: (info?.silverKeyInfo.keyClue)!, hint: (info?.silverKeyInfo.keyHint)!, isFloor: (info?.silverKeyInfo.keyImg.isFloor)!)
        setKeyDBInfo(us: us, keyName: "copperKey", clue: (info?.copperKeyInfo.keyClue)!, hint: (info?.copperKeyInfo.keyHint)!, isFloor: (info?.copperKeyInfo.keyImg.isFloor)!)
        
    }
    func setKeyDBInfo(us: String, keyName: String, clue: String, hint: String ,isFloor: Bool){
        
        var databaseRef = Database.database().reference().child(us).child("keys").child(keyName).child("clue")
        databaseRef.setValue(clue, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        databaseRef = Database.database().reference().child(us).child("keys").child(keyName).child("hint")
        databaseRef.setValue(hint, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        databaseRef = Database.database().reference().child(us).child("keys").child(keyName).child("keyImgInfo").child("isFloor")
        databaseRef.setValue(isFloor, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setBgImg()
        info?.boxImg = ImageInfo()
        delegateSetting()
        print("viewDidLoad")
        // Do any additional setup after loading the view.
    }
    func delegateSetting(){
        gameTitle.delegate = self
        gameIntroduction.delegate = self
        boxPos.delegate = self
        winMsg.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // press "Enter" to close the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // press the view to close the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        if let selectedImage = selectedImageFromPicker {
            self.info?.boxImg?.image = selectedImageFromPicker!
            DispatchQueue.main.async {
                self.setImage(img: selectedImage)
                self.imgSelected = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func setImage(img: UIImage){
        let emptyImg = UIImage()
        if(img.size.width > img.size.height){
            boxImage.image = img
            boxImageVertical.image = emptyImg
        } else {
            boxImage.image = emptyImg
            boxImageVertical.image = img
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editGold" {
            self.prepareEditingKey(for: segue, type: keyType.gold.rawValue)
            checkRefilled(for: segue, keyinformation: info?.goldKeyInfo)
        } else if segue.identifier == "editSilver" {
            self.prepareEditingKey(for: segue, type: keyType.silver.rawValue)
            checkRefilled(for: segue, keyinformation: info?.silverKeyInfo)
        } else if segue.identifier == "editCopper" {
            self.prepareEditingKey(for: segue, type: keyType.copper.rawValue)
            checkRefilled(for: segue, keyinformation: info?.copperKeyInfo)
        } else if segue.identifier == "uploadSegue"{
            prepareUploadData()
            passUploadData(for: segue)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func prepareEditingKey(for segue: UIStoryboardSegue, type: String) {
        let keyInfoVC = segue.destination as! KeyInfoViewController
        keyInfoVC.KType = type
    }
    
    func checkRefilled(for segue: UIStoryboardSegue, keyinformation: KeyInfo?){
        guard keyinformation != nil else{
            return
        }
        let keyInfoVC = segue.destination as! KeyInfoViewController
        keyInfoVC.KInfo = keyinformation
    }
    
    func prepareUploadData(){
        info?.gameName = gameTitle.text!
        info?.introduction = gameIntroduction.text!
        info?.boxPos = boxPos.text!
        info?.winMessage = winMsg.text!
        info?.boxImg?.isFloor = (boxImgIsFloor.selectedSegmentIndex == 0)
        print("Get upLoad information!")
    }
    
    func passUploadData(for segue: UIStoryboardSegue){
        let uploadingVC = segue.destination as! UploadingViewController
        uploadingVC.info = self.info
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
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "uploadSegue") && !TESTING {
            return checkImgInfo(isSelected: self.imgSelected, message: "請選擇寶箱位置照片")
                && checkKeyInfo(key: self.info?.goldKeyInfo, message: "請填入金鑰匙資訊")
                && checkKeyInfo(key: self.info?.silverKeyInfo, message: "請填入銀鑰匙資訊")
                && checkKeyInfo(key: self.info?.copperKeyInfo, message: "請填入銅鑰匙資訊")
                && checkTextEmpty(str: self.gameTitle.text!, message: "請填寫標題名稱")
                && checkTextEmpty(str: self.gameIntroduction.text!, message: "請填寫遊戲描述")
                && checkTextEmpty(str: self.boxPos.text!, message: "請填寫寶箱位置")
                && checkTextEmpty(str: self.winMsg.text!, message: "請填寫勝利訊息")
        }
        // by default, transition
        return true
    }
    func checkTextEmpty(str: String, message: String) -> Bool{
        if (str.isEmpty) {
            let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    func checkKeyInfo(key: KeyInfo?, message: String) -> Bool{
        guard key != nil else {
            let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    func checkImgInfo(isSelected: Bool, message: String) -> Bool{
        if isSelected {
            return true
        } else {
            let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
}

