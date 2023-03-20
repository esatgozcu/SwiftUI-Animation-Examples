//
//  BlinkCircleVM.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/14.
//

import SwiftUI

class BlinkCircleVM : ObservableObject {
    
    var startSize = 0.2
    var endSize = 2.0
    var animTime : Double = 0.05
    @Published var currentSize = 0.2
    @Published var viewID = 0
    @Published var rowCount : Int = 2
    
    func calculateOffsetX(width: CGFloat, i: Int) -> CGFloat{
        let onePiece = Double(width/Double(rowCount))
        let result = onePiece*Double(i%Int(rowCount))
        return CGFloat(result)
    }
    func calculateOffsetY(size: CGSize, i: Int) -> CGFloat{
        let onePiece = Int(size.width/Double(rowCount))
        let result = onePiece*Int(i/Int(rowCount))
        let startPosition = Int((size.height/2) - (size.width/2))
        return CGFloat(result + startPosition)
    }
    func getItemSize()->Int{
        return rowCount*rowCount
    }
}
