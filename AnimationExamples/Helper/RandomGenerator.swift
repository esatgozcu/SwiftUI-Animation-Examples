//
//  RandomGenerator.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/13.
//

import Foundation

class RandomGenerator {
    static func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: Int) -> [CGFloat] {
        var uniqueNumbers = Set<CGFloat>()
        while uniqueNumbers.count < numberOfRandoms {
            uniqueNumbers.insert(CGFloat(Int(arc4random_uniform(UInt32(maxNum) + 1)) + minNum))
        }
        return uniqueNumbers.shuffled()
    }
}
