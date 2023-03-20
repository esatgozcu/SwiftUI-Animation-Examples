//
//  CirclesRotationView.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/15.
//

import SwiftUI

struct CirclesRotationView: View {
    
    @StateObject var viewModel = CircleRotationVM()
    @State private var scaleInOut = false
    @State private var rotateInOut = false
    @State private var moveInOut = false
    
    var body: some View {
        ZStack (alignment: .center){
            ForEach(0..<viewModel.itemCount, id:\.self){ i in
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.red, .white]), startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                        .offset(y: moveInOut ? -viewModel.itemSize/2 : 0)
                    Circle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .bottom, endPoint: .top)
                        )
                        .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                        .offset(y: moveInOut ? viewModel.itemSize/2 : 0)
                }.opacity(0.5)
                    .rotationEffect(.degrees((Double(i)*viewModel.degree)))
            }
        }
        .rotationEffect(
            .degrees(rotateInOut ? 180 : 0)
        )
        .scaleEffect(scaleInOut ? 1.0 : 1/4)
        .animation(
                .easeInOut(duration: 0.5)
                .repeatForever(autoreverses: true)
                .speed(2/8), value: scaleInOut
        )
        .onAppear {
            moveInOut.toggle()
            scaleInOut.toggle()
            rotateInOut.toggle()
        }
    }
}
