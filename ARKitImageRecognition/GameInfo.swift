//
//  GameInfo.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/7.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

let TESTING = false
var gameState: Int = _GameState.start.rawValue
var bgmPlayer: AVAudioPlayer?

var globalCashingCount:[Int] = [0, 0, 0, 0]
var findThings:[Bool] = [false, false, false, false]
enum _GameState: Int{
    case start = 1 // not find box yet
    case findBox = 2 // find the box, start to find the 3 keys
    case findKeys = 4 // find all the keys
    case finish = 8 // fininsh game!
}
enum keyType: String {
    case gold = "金"
    case silver = "銀"
    case copper = "銅"
}
class GameSimpleInfo{
    var gameID: String = ""
    var title: String = ""
    var introduction: String = ""
}
class GameInfo{
    var gameName: String = ""
    var introduction: String = ""
    var boxPos: String = ""
    var winMessage: String = ""
    var boxImg: ImageInfo!
    var goldKeyInfo: KeyInfo!
    var silverKeyInfo: KeyInfo!
    var copperKeyInfo: KeyInfo!
}
class KeyInfo{
    var keyClue: String = ""
    var keyHint: String = ""
    var keyImg: ImageInfo!
}
class ImageInfo{
    var image: UIImage!
    var isFloor: Bool = true
}
