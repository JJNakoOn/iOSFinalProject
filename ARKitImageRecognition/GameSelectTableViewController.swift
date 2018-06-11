//
//  GameSelectTableViewController.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/10.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GameSelectTableViewController: UITableViewController {
    
    var gameList: [GameSimpleInfo] = []
    var presentGame: GameSimpleInfo = GameSimpleInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        setBgImg()
        loadDataFromFireBase()
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
        //self.view.insertSubview(backgroundImage, at: 0)
        tableView.backgroundView = backgroundImage

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func loadDataFromFireBase(){
        let ref = Database.database().reference()
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            if let gameDictionary = snapshot.value as? [String: AnyObject]{
                for (gameID, data) in gameDictionary {
                    let tempGSInfo = GameSimpleInfo()
                    tempGSInfo.gameID = gameID
                    let dataDictionary = data as! [String: AnyObject]
                    tempGSInfo.title = dataDictionary["name"] as! String
                    tempGSInfo.introduction = dataDictionary["introduction"] as! String
                    self.gameList.append(tempGSInfo)
                    self.tableView.reloadData()
                }
            }
            //SList.scoreList.append(tempValue)
        })
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return Int(truncating: NSNumber(value:presentGame.title != ""))
        }else{
            return gameList.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "已下載地圖"
        } else {
            return "可下載地圖列表"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameIntroCell", for: indexPath) as! GameSelectTableViewCell
        if(indexPath.section == 0){
            print("get the first seciton")
        } else {
        let game = gameList[indexPath.row]
            cell.gameTitle.text = game.title
            cell.gameIntro.text = game.introduction
            cell.gameLogo = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: "gameLogo.png")
                return imageView
            }()
        }
        return cell
        
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: prevent from redownloading
        if(indexPath.section == 0){
            return
        }else{
            print("Start downloading game of \(gameList[indexPath.row].title)")
            
        }
    }

}
