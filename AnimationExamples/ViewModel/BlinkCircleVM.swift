//
//  BlinkCircleVM.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/14.
//

import SwiftUI

class BlinkCircleVM : ObservableObject {
    func calculateOffsetX(width: CGFloat, i: Int, rowCount: Int) -> CGFloat{
        let onePiece = Double(width/Double(rowCount))
        let result = onePiece*Double(i%Int(rowCount))
        return CGFloat(result)
    }
    func calculateOffsetY(size: CGSize, i: Int, rowCount: Int) -> CGFloat{
        let onePiece = Int(size.width/Double(rowCount))
        let result = onePiece*Int(i/Int(rowCount))
        let startPosition = Int((size.height/2) - (size.width/2))
        return CGFloat(result + startPosition)
    }
}
