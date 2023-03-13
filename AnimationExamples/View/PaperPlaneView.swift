//
//  PaperPlaneView.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/13.
//

import SwiftUI

struct PaperPlaneView: View {
    
    @StateObject var viewModel = PaperPlaneVM()
    @State var action = false
    
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<viewModel.itemSize, id: \.self) { id in
                Image("paper_plane")
                    .resizable()
                    .frame(width: viewModel.randomSize[id],
                          height: viewModel.randomSize[id]
                    )
                    .offset(x: action ? (geo.size.width + viewModel.randomSize[id]) : -viewModel.randomSize[id],
                            y: action ? (viewModel.randomYList[id] - geo.size.width) : viewModel.randomYList[id]
                    )
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

struct PaperPlaneView_Preview: PreviewProvider {
    static var previews: some View {
        PaperPlaneView()
    }
}

