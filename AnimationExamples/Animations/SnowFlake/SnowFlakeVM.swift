//
//  SnowFlakeVM.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/13.
//

import SwiftUI

class SnowFlakeVM : ObservableObject {
    
    var randomXList = [CGFloat]()
    var randomSize = [CGFloat]()
    var randomDurationMillis = [CGFloat]()
    var randomDelayMillis = [CGFloat]()
    var screenWidth = Int(UIScreen.main.bounds.width)
    var itemSize = 20
    
    init() {
        randomXList             = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: -20  , maxNum: screenWidth+20)
        randomSize              = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: 30   , maxNum: 40)
        randomDurationMillis    = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: 3000 , maxNum: 3100)
        randomDelayMillis       = RandomGenerator.uniqueRandoms(numberOfRandoms: itemSize, minNum: 0    , maxNum: 4000)
    }
}


