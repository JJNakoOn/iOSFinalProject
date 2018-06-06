//
//  ViewController.swift
//  Image Recognition
//
//  Created by Jayven Nhan on 3/20/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    
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
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        label.text = "Move camera around to detect images"
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
        node.addChildNode(planeNode)*/
        
        let overlayNode = self.getNode(withImageName: imageName)
        overlayNode.opacity = 0
        overlayNode.position.y = 0.1
        overlayNode.position.z = 0.05
        overlayNode.runAction(self.wallFadeAndSpinAction)
        
        node.addChildNode(overlayNode)
        
        DispatchQueue.main.async {
            self.label.text = "Image detected: \"\(imageName)\""
        }
    }
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 1.50),
            .fadeOpacity(to: 0.15, duration: 1.50),
            .fadeOpacity(to: 0.85, duration: 1.50),
            .fadeOut(duration: 0.75),
            .removeFromParentNode()
            ])
    }
    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
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
    
}
