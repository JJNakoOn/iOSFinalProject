//
//  ClueTableViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/11.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class ClueTableViewController: UITableViewController {

    var info:GameInfo = GameInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        setBgImg()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func setBgImg(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "editorbackground.png")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        backgroundImage.alpha = 0.5
        tableView.backgroundView = backgroundImage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "寶箱資訊"
        } else {
            return "鑰匙資訊"
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else if(gameState >= _GameState.findBox.rawValue){
            return 3
        }else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClueCell", for: indexPath) as! ClueTableViewCell
        if(indexPath.section == 0){
            cell.title.text = "寶箱"
            cell.detail.text = info.boxPos
            cell.icon.image = UIImage(named: "boxClose.png")
            cell.clueState.text = wordSuccess(isDone: findThings[0])
        } else {
            switch(indexPath.row){
                case 0: // gold key
                    cell.title.text = "金鑰匙"
                    cell.detail.text = info.goldKeyInfo.keyClue
                    cell.icon.image = UIImage(named: "goldKeyImage.png")
                    cell.clueState.text = wordSuccess(isDone: findThings[1])
                case 1: // silver key
                    cell.title.text = "銀鑰匙"
                    cell.detail.text = info.silverKeyInfo.keyClue
                    cell.icon.image = UIImage(named: "silverKeyImage.png")
                    cell.clueState.text = wordSuccess(isDone: findThings[2])
                case 2: // copper key
                    cell.title.text = "銅鑰匙"
                    cell.detail.text = info.copperKeyInfo.keyClue
                    cell.icon.image = UIImage(named: "copperKeyImage.png")
                    cell.clueState.text = wordSuccess(isDone: findThings[3])
                default:
                    cell.title.text = "錯誤"
                    cell.detail.text = "錯誤"
            }
        }
        //cell.title.text = game.title
        //cell.detail.text = game.introduction
        cell.icon.translatesAutoresizingMaskIntoConstraints = false
        cell.icon.layer.cornerRadius = 15
        cell.icon.layer.masksToBounds = true
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowClueDetailSegue" {
            guard let cell = sender as? ClueTableViewCell else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpeningDetail(for: segue, sender: cell)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    func wordSuccess(isDone: Bool) -> String{
        if(isDone){
            return "完成"
        }else{
            return "尋找中"
        }
    }
    func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: UITableViewCell) {
        let detailClueVC = segue.destination as! DetailClueViewController
        let senderIndexPath = self.tableView.indexPath(for: sender)!
        if(senderIndexPath.section == 0){ // treasureBox
            detailClueVC.keyInfo = KeyInfo()
            detailClueVC.keyInfo.keyClue = info.boxPos
            detailClueVC.keyInfo.keyHint = ""
            detailClueVC.title = "寶箱資訊"
            detailClueVC.cashingCount = globalCashingCount[0]
        }
        else{
            switch(senderIndexPath.row){
                case 0: // gold key
                    detailClueVC.keyInfo = info.goldKeyInfo
                    detailClueVC.title = "金鑰匙資訊"
                    detailClueVC.cashingCount = globalCashingCount[1]
                case 1: // silver key
                    detailClueVC.keyInfo = info.silverKeyInfo
                    detailClueVC.title = "銀鑰匙資訊"
                    detailClueVC.cashingCount = globalCashingCount[2]
                case 2: // copper key
                    detailClueVC.keyInfo = info.copperKeyInfo
                    detailClueVC.title = "銅鑰匙資訊"
                    detailClueVC.cashingCount = globalCashingCount[3]
                default:
                    return
            }
        }
    }
    
    @IBAction func saveUnwindSegueFromKeyInfoView(_ segue: UIStoryboardSegue){
        guard let keyInfo = segue.source as? DetailClueViewController else {return}
        switch keyInfo.title {
            case "寶箱資訊":
                globalCashingCount[0] = keyInfo.cashingCount
            case "金鑰匙資訊":
                globalCashingCount[1] = keyInfo.cashingCount
            case "銀鑰匙資訊":
                globalCashingCount[2] = keyInfo.cashingCount
            case "銅鑰匙資訊":
                globalCashingCount[3] = keyInfo.cashingCount
            default:
                print("ERROR when showing IMAGE")
                return
        }
    }
}
