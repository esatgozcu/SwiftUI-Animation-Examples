//
//  BlinkCircleView.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/14.
//

import SwiftUI

struct BlinkCircleView: View {
    @StateObject var viewModel = BlinkCircleVM()
    @State var currentSize = 0.2
    @State private var viewID = 0
    @State var rowCount : Int = 2
    var startSize = 0.2
    var endSize = 2.0
    var animTime : Double = 0.05
    var itemSize : Int{
        get{
            rowCount*rowCount
        }
    }
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<itemSize, id: \.self) { id in
                Circle()
                    .foregroundColor(.black)
                    .frame(width: geo.size.width/CGFloat(rowCount), height: geo.size.width/CGFloat(rowCount))
                    .scaleEffect(currentSize)
                    .opacity(currentSize)
                    .animation(.linear.delay(Double(id)*animTime))
                    .offset(
                        x: viewModel.calculateOffsetX(width: geo.size.width, i: id, rowCount: rowCount),
                        y: viewModel.calculateOffsetY(size: geo.size, i: id, rowCount: rowCount)
                    ).id(viewID)
            }
        }.onAppear{
            startAnim()
            activeTimer()
        }.ignoresSafeArea()
    }
    private func startAnim(){
        withAnimation(.linear(duration: animTime/2).repeatCount(1, autoreverses: false)){
            currentSize = endSize
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animTime/2) {
            withAnimation(.linear(duration: animTime/2).repeatCount(1, autoreverses: false)){
                currentSize = startSize
            }
        }
    }
    private func activeTimer(){
        Timer.scheduledTimer(withTimeInterval: animTime*Double(itemSize), repeats: true) { timer in
            viewID += 1
            rowCount += 1
            startAnim()
            timer.invalidate()
            self.activeTimer()
        }
    }
}
