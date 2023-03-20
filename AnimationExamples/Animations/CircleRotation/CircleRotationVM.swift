//
//  CircleRotationVM.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/20.
//

import SwiftUI

class CircleRotationVM: ObservableObject{
    var itemSize = UIScreen.main.bounds.size.width / 2.0
    var itemCount = 3
    var degree : Double {get{ return 360.0/Double(itemCount) }}
}
