//
//  PaperPlaneVM.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/13.
//

import SwiftUI

class PaperPlaneVM : ObservableObject {
    
    var randomYList = [CGFloat]()
    var randomSize = [CGFloat]()
    var randomDurationMillis = [CGFloat]()
    var randomDelayMillis = [CGFloat]()
    var screenHeight = Int(UIScreen.main.bounds.height)
    var itemSize = 20
    
    init() {
        randomYList             = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: 100  , maxNum: screenHeight)
        randomSize              = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: 20   , maxNum: 100)
        randomDurationMillis    = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: 750  , maxNum: 1250)
        randomDelayMillis       = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: 0    , maxNum: 1000)
    }
}


