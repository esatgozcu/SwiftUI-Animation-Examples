//
//  SimpleNavigationVM.swift
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
    var screenWidht = UIScreen.main.bounds.width
    
    init() {
        randomXList = RandomGenerator.uniqueRandoms(numberOfRandoms: 20, minNum: -20, maxNum: Int(screenWidht)+20)
        randomSize = RandomGenerator.uniqueRandoms(numberOfRandoms: 20, minNum: 30, maxNum: 40)
        randomDurationMillis = RandomGenerator.uniqueRandoms(numberOfRandoms: 20, minNum: 3000, maxNum: 3100)
        randomDelayMillis = RandomGenerator.uniqueRandoms(numberOfRandoms: 20, minNum: 0, maxNum: 4000)
    }
}


