//
//  UploadingViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/10.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class UploadingViewController: UIViewController {

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    let shapeLayer = CAShapeLayer()
    var uploadCount: Int = 0 // total:30
    let finalCount: Int = 30
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0 %"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    var info: GameInfo? = GameInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        setBgImg()
        setupLayout()
        if(TESTING){
            finishButton.isHidden = false
            finishButton.alpha = 1
        } else{
            startUploading()
        }
        // Do any additional setup after loading the view.
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
    func setupLayout(){
        
        finishButton.isHidden = true
        finishButton.alpha = 0
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        
    }
    func setBgImg(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "editorbackground.png")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        backgroundImage.alpha = 0.5
        self.view.insertSubview(backgroundImage, at: 0)
    }
    func startUploading(){
        uploadCount = 0
        let uniqueString = NSUUID().uuidString
        uploadImage(title: (info?.gameName)!, image: (info?.boxImg.image)!, name: "box", us: uniqueString)
        uploadImage(title: (info?.gameName)!, image: (info?.goldKeyInfo.keyImg.image)!, name: "goldKey", us: uniqueString)
        uploadImage(title: (info?.gameName)!, image: (info?.silverKeyInfo.keyImg.image)!, name: "silverKey", us: uniqueString)
        uploadImage(title: (info?.gameName)!, image: (info?.copperKeyInfo.keyImg.image)!, name: "copperKey", us: uniqueString)
        setDatabaseInfo(us: uniqueString)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadImage(title: String, image: UIImage, name: String, us: String) {
        
        // upload the box Image
        let storageRef = Storage.storage().reference().child(title).child("\(name).jpg")
        
        if let ImageData = UIImageJPEGRepresentation(image, 0.4){
            //storage save
            storageRef.putData(ImageData, metadata: nil){ (metadata, error) in
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
                                    self.updateCount(num: 4)
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
                                    self.updateCount(num: 4)
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
        updateCount(num: 1)
        
        databaseRef = Database.database().reference().child(us).child("introduction")
        databaseRef.setValue(info?.introduction, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        updateCount(num: 1)
        
        databaseRef = Database.database().reference().child(us).child("boxPos")
        databaseRef.setValue(info?.boxPos, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        updateCount(num: 1)
        
        databaseRef = Database.database().reference().child(us).child("boxImgInfo").child("isFloor")
        databaseRef.setValue(info?.boxImg.isFloor, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        updateCount(num: 1)
        
        databaseRef = Database.database().reference().child(us).child("winMsg")
        databaseRef.setValue(info?.winMessage, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        updateCount(num: 1)
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
        updateCount(num: 1)
        databaseRef = Database.database().reference().child(us).child("keys").child(keyName).child("hint")
        databaseRef.setValue(hint, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        updateCount(num: 1)
        databaseRef = Database.database().reference().child(us).child("keys").child(keyName).child("keyImgInfo").child("isFloor")
        databaseRef.setValue(isFloor, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                print("Database Error: \(error!.localizedDescription)")
            }
        })
        updateCount(num: 1)
    }
    func updateCount(num: Int){
        self.uploadCount += num
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int((self.uploadCount*100)/self.finalCount)) %"
            self.shapeLayer.strokeEnd = CGFloat(self.uploadCount)/CGFloat(self.finalCount)
        }
        if(self.uploadCount == self.finalCount){
            self.percentageLabel.text = "100 %"
            finishButton.isHidden = false
            finishButton.alpha = 1
            msgLabel.text = "上傳完成!"
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backToMenu"){
            let destination = segue.destination
            let slideAnimator = SlideAnimator()
            destination.transitioningDelegate = slideAnimator
        }
        else{
            super.prepare(for: segue, sender: sender)
        }
    }
     */

}
