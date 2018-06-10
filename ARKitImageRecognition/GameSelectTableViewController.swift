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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromFireBase()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//                    print(tempGSInfo.title)
//                    print(tempGSInfo.introduction)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameIntroCell", for: indexPath)
        let game = gameList[indexPath.row]
        cell.textLabel?.text = game.title
        cell.detailTextLabel?.text = game.introduction
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: prevent from redownloading
        print("Start downloading game of \(gameList[indexPath.row].title)")
    }

}
