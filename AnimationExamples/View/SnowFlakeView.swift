//
//  Simple Navigation.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/13.
//

import SwiftUI

struct SnowFlakeView: View {
    
    @StateObject var viewModel = SnowFlakeVM()
    @State var action = false
    
    var body: some View {
        GeometryReader { geo in
            ForEach(0...19, id: \.self) { id in
                Image("snow_flake")
                    .resizable()
                    .frame(width: viewModel.randomSize[id],
                           height: viewModel.randomSize[id])
                    .offset(x: viewModel.randomXList[id],
                            y: action ? geo.size.height : 0 - viewModel.randomSize[id])
                    .animation(
                        .linear(duration: Double(viewModel.randomDurationMillis[id])/1000)
                        .delay(Double(viewModel.randomDelayMillis[id])/1000)
                        .repeatCount(10, autoreverses: false)
                    )
            }
        }.ignoresSafeArea()
            .onAppear{
                action = true
            }
    }
}

struct SimpleNavigation_Preview: PreviewProvider {
    static var previews: some View {
        SnowFlakeView()
    }
}
