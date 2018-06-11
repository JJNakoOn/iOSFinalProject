//
//  ViewController.swift
//  Image Recognition
//
//  Created by Jayven Nhan on 3/20/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import ARKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    var info: GameInfo = GameInfo()
    var player: AVAudioPlayer?
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 30
    let waitDuration: TimeInterval = 0.5
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: CGFloat.pi * 360 / 90, z: 0, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var wallFadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 90, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
        ])
    }()
    
    lazy var openBoxAction: SCNAction = {
        return SCNAction.rotateBy(x: -CGFloat.pi / 2, y: 0, z: 0, duration: 0.5)
    }()
    
    lazy var treeNode: SCNNode = {
        guard let scene = SCNScene(named: "tree.scn"),
            let node = scene.rootNode.childNode(withName: "tree", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.005
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x = -.pi / 2
        return node
    }()
    
    lazy var bookNode: SCNNode = {
        guard let scene = SCNScene(named: "book.scn"),
            let node = scene.rootNode.childNode(withName: "book", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.1
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    lazy var mountainNode: SCNNode = {
        guard let scene = SCNScene(named: "mountain.scn"),
            let node = scene.rootNode.childNode(withName: "mountain", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.25
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles.x += -.pi / 2
        return node
    }()
    
    lazy var goldKeyNode: SCNNode = {
        guard let scene = SCNScene(named: "key_gold.dae"),
            let node = scene.rootNode.childNode(withName: "key_gold", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.0002
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    lazy var silverKeyNode: SCNNode = {
        guard let scene = SCNScene(named: "key_silver.dae"),
            let node = scene.rootNode.childNode(withName: "key_silver", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.0002
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    lazy var copperKeyNode: SCNNode = {
        guard let scene = SCNScene(named: "key_copper.dae"),
            let node = scene.rootNode.childNode(withName: "key_copper", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.0002
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    lazy var treasureBoxNode: SCNNode = {
        guard let scene = SCNScene(named: "treasureBox.dae"),
            let node = scene.rootNode.childNode(withName: "treasureBox", recursively: false) else { return SCNNode() }
        let scaleFactor = 0.001
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        configureLighting()
        self.title = info.gameName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        sceneView.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
        resetTrackingConfiguration()
    }
    
    func createARReference(name: String)->ARReferenceImage?{
        guard let imageFromBundle = getSavedImage(named: name + ".jpg") else{
            print("NOOOOOOOOOOOOOOOO~~~ IMAGE YO!")
            return nil
        }
        guard let imageToCIImage = CIImage(image:imageFromBundle),
            let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return nil  }
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
        arImage.name = name
       
        return arImage
    }
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    func resetTrackingConfiguration() {
        // var referenceImage: Set<ARReferenceImage>?
        
            let configuration = ARWorldTrackingConfiguration()
        
            if let arImageBox = self.createARReference(name: "treasureBox"),
                let arImageGold = self.createARReference(name: "goldKey"),
                let arImageSilver = self.createARReference(name: "silverKey"),
                let arImageCopper = self.createARReference(name: "copperKey"){
                configuration.detectionImages = [arImageBox, arImageGold, arImageSilver, arImageCopper] as Set<ARReferenceImage>
            }
        
            let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
            self.sceneView.session.run(configuration, options: options)
        
            self.label.text = "Move camera around to detect images"
        }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name ?? "no name"
        
        /*
        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.20
        planeNode.eulerAngles.x = -.pi / 2
        
        planeNode.runAction(imageHighlightAction)
        node.addChildNode(planeNode)
        */
        
        
        let overlayNode = self.getNode(withImageName: imageName)
        overlayNode.opacity = 0
        overlayNode.position.y = 0.1
        overlayNode.position.z = 0.05
        overlayNode.runAction(self.fadeAndSpinAction)
        
        node.addChildNode(overlayNode)
        
        DispatchQueue.main.async {
            self.label.text = "Image detected: \"\(imageName)\""
            self.playSound(imageName: imageName, isWin: false)
        }
    }
    /*
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }*/
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 2.50),
            .fadeOpacity(to: 0.15, duration: 2.50),
            .fadeOpacity(to: 0.85, duration: 2.50),
            .fadeOut(duration: 0.75),
            .removeFromParentNode()
            ])
    }
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "treasureBox":
            node = treasureBoxNode
        case "goldKey":
            node = goldKeyNode
        case "silverKey":
            node = silverKeyNode
        case "copperKey":
            node = copperKeyNode
            /*
        case "Book":
            node = copperKeyNode
        case "Snow Mountain":
            node = silverKeyNode
        case "Trees In the Dark":
            node = goldKeyNode
        case "handsome":
            node = silverKeyNode
        case "darts":
            node = treasureBoxNode
        case "za7za8":
            node = goldKeyNode
        case "file":
            node = silverKeyNode
        case "liangG":
            node = treasureBoxNode
        case "sofa":
            node = treasureBoxNode
        case "curtain":
            node = treasureBoxNode
        case "wifi":
            node = treasureBoxNode
        case "bed":
            node = treasureBoxNode
            */
        default:
            break
        }
        return node
    }
    //Method called when tap
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                if checkHitObj(targetName: "treasureBox", myNode: tappedNode!) {
                    
                    let rotateNode = treasureBoxNode.childNode(withName: "joint1", recursively: false)
                    if(rotateNode == nil){
                        print("no joint1")
                    }
                    rotateNode?.runAction(self.openBoxAction)
                }
                else{
                    print("wrong node")
                }
            }
            else{
                print("Tap empty yo~")
            }
        }
    }
    
    func checkHitObj(targetName: String, myNode: SCNNode) -> Bool{
        var node:SCNNode = myNode
        if(myNode.name == targetName){
            return true
        }
        repeat {
            node = node.parent!
            if(node.name == targetName){
                return true
            }
        } while node.parent != nil
        return false
    }
    func playSound(imageName: String, isWin: Bool) {
        var filename:String = ""
        if isWin{
            filename = "win"
        }
        else{
            if imageName == "treasureBox"{
                filename = "getTreasureBox"
            } else {
                filename = "getKey"
            }
        }
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowClueTable"){
            let clueTableVC = segue.destination as! ClueTableViewController
            clueTableVC.info = self.info
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
}
