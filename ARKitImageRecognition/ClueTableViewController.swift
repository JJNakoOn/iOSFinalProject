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
        }else if(gameState >= 1){
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
        } else {
            switch(indexPath.row){
                case 0: // gold key
                    cell.title.text = "金鑰匙"
                    cell.detail.text = info.goldKeyInfo.keyClue
                    cell.icon.image = UIImage(named: "goldKeyImage.png")
                case 1: // silver key
                    cell.title.text = "銀鑰匙"
                    cell.detail.text = info.silverKeyInfo.keyClue
                    cell.icon.image = UIImage(named: "silverKeyImage.png")
                case 2: // copper key
                    cell.title.text = "銅鑰匙"
                    cell.detail.text = info.copperKeyInfo.keyClue
                    cell.icon.image = UIImage(named: "copperKeyImage.png")
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

}
