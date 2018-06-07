//
//  GameInfo.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/7.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import Foundation
import UIKit

class GameInfo{
    var gameName: String = ""
    var introduction: String = ""
    var boxHint: String = ""
    var winMessage: String = ""
    var boxImg: ImageInfo? = nil
    var goldKeyInfo: KeyInfo? = nil
    var silverKeyInfo: KeyInfo? = nil
    var copperKeyInfo: KeyInfo? = nil
}
class KeyInfo{
    var keyHint1: String = ""
    var keyHint2: String = ""
    var image: UIImage? = nil
}
class ImageInfo{
    var image: UIImage? = nil
    var isFloor: Bool = true
}
