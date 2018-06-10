//
//  GameInfo.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/7.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import Foundation
import UIKit

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
