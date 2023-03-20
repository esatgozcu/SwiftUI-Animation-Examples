//
//  BlinkCircleView.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/14.
//

import SwiftUI

struct BlinkCircleView: View {
    
    @StateObject var vm = BlinkCircleVM()
    
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<vm.getItemSize(), id: \.self) { id in
                Circle()
                    .foregroundColor(.black)
                    .frame(width: geo.size.width/CGFloat(vm.rowCount), height: geo.size.width/CGFloat(vm.rowCount))
                    .scaleEffect(vm.currentSize)
                    .opacity(vm.currentSize)
                    .animation(.linear.delay(Double(id)*vm.animTime))
                    .offset(
                        x: vm.calculateOffsetX(width: geo.size.width, i: id),
                        y: vm.calculateOffsetY(size: geo.size, i: id)
                    ).id(vm.viewID)
            }
        }.onAppear{
            startAnim()
            activeTimer()
        }.ignoresSafeArea()
    }
    private func startAnim(){
        withAnimation(.linear(duration: vm.animTime/2).repeatCount(1, autoreverses: false)){
            vm.currentSize = vm.endSize
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + vm.animTime/2) {
            withAnimation(.linear(duration: vm.animTime/2).repeatCount(1, autoreverses: false)){
                vm.currentSize = vm.startSize
            }
        }
    }
    private func activeTimer(){
        Timer.scheduledTimer(withTimeInterval: vm.animTime*Double(vm.getItemSize()), repeats: true) { timer in
            vm.viewID += 1
            vm.rowCount += 1
            startAnim()
            timer.invalidate()
            self.activeTimer()
        }
    }
}
