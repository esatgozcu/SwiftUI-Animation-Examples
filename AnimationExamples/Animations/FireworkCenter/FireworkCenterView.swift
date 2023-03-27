//
//  FireworkCenterView.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/26.
//

import SwiftUI

struct FireworkCenterView: View{
    
    @State var counter = 0
    
    var body: some View{
        ZStack{
            Text("🎉").onTapGesture {
                counter += 1
            }.padding(.bottom, 40)
            
            FireworkView(counter: $counter)
            
        }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottom
        ).background(Color.black)
            .ignoresSafeArea()
    }
}

struct FireworkView: View{
    
    @Binding var counter: Int
    @StateObject var vm = FireworkCenterVM()
    @State var animate = 0
    @State var finishedAnimationCounter = 0
    @State var firstAppear = false
    
    var body: some View{
        ZStack{
            ForEach(finishedAnimationCounter..<animate, id:\.self){ i in
                FireworkContainer(
                    vm: vm,
                    finishedAnimationCounter: $finishedAnimationCounter
                )
            }
        }
        .onAppear(){
            firstAppear = true
        }
        .onChange(of: counter){value in
            if firstAppear{
                for i in 0...vm.repetitions{
                    DispatchQueue.main.asyncAfter(deadline: .now() + vm.repetitionInterval * Double(i)) {
                        animate += 1
                    }
                }
            }
        }
    }
}

struct FireworkContainer: View {
    
    @StateObject var vm: FireworkCenterVM
    @Binding var finishedAnimationCounter:Int
    @State var firstAppear = true
    @State var randomX = Double.random(in: -100...100)
    @State var randomY = Double.random(in: 200.0...UIScreen.main.bounds.size.height-200)
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    @State var withPath = Int.random(in: 0...1)

    var body: some View{
        ZStack{
            ForEach(0..<vm.pieceCount, id:\.self){ i in
                FireworkFrame(
                    vm: vm,
                    index: i,
                    launchHeight: randomY,
                    color: getColor(),
                    withPath: withPath,
                    duration: getExplosionAnimationDuration()
                )
            }
        }
        .offset(x: location.x, y: location.y)
        .onAppear(){
            if firstAppear{
                withAnimation(Animation.timingCurve(0.075, 0.690, 0.330, 0.870, duration: vm.launchAnimDuration).repeatCount(1)) {
                    location.x = randomX
                    location.y = -randomY
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + getAnimDuration()) {
                    //Clear
                    self.finishedAnimationCounter += 1
                }
                firstAppear = false
            }
        }
    }
    func getAnimDuration() -> CGFloat{
        return vm.explosionAnimationDuration + vm.launchAnimDuration
    }
    func getColor() -> Color{
        return vm.colors.randomElement()!
    }
    func getRandomExplosionTimeVariation() -> CGFloat {
        return CGFloat((0...999).randomElement()!) / 2100
    }
    func getExplosionAnimationDuration() -> CGFloat {
        return vm.explosionAnimationDuration + getRandomExplosionTimeVariation()
    }
}

struct FireworkFrame: View{

    @StateObject var vm: FireworkCenterVM
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    @State var index: Int
    @State var launchHeight: CGFloat
    @State var percentage: CGFloat = 0.0
    @State var strokeWidth: CGFloat = 2.0
    @State var color: Color
    @State var withPath: Int
    @State var duration: CGFloat
    
    var body: some View{
        ZStack{
            FireworkItem(vm: vm, shape: getShape(), size: vm.pieceSize, color: color)
                .offset(x: location.x, y: location.y)
                .onAppear{
                    withAnimation(
                        Animation
                            .timingCurve(0.0, 1.0, 1.0, 1.0, duration: duration)
                            .delay(vm.launchAnimDuration).repeatCount(1)
                    ){
                        location.x = getDistance() * cos(deg2rad(getRandomAngle()))
                        location.y = -getDistance() * sin(deg2rad(getRandomAngle()))
                    }
                }
            
            if withPath == 0{
                Path { path in
                    path.move(to: .zero)
                    path.addLine(
                        to: CGPoint(
                            x: getDistance() * cos(deg2rad(getRandomAngle())),
                            y: -getDistance() * sin(deg2rad(getRandomAngle()))
                        )
                    )
                }.trim(from: 0.0, to: percentage)
                 .stroke(color, lineWidth: strokeWidth)
                 .frame(width: 1.0, height: 1.0)
                 .onAppear{
                     withAnimation(
                         Animation
                             .timingCurve(0.0, 1.0, 1.0, 1.0, duration: duration)
                             .delay(vm.launchAnimDuration).repeatCount(1)
                     ){
                         percentage = 1.0
                         strokeWidth = 0.0
                     }
                 }
            }
        }
    }
    func getRandomAngle() -> CGFloat{
        return (360.0 / Double(vm.pieceCount)) * Double(index)
    }
    func getShape() -> AnyView {
        return vm.getShapes().randomElement()!
    }
    func getDistance() -> CGFloat {
        return vm.radius + (launchHeight / 10)
    }
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * CGFloat.pi / 180
    }
}

struct FireworkItem: View {
    
    @StateObject var vm: FireworkCenterVM
    @State var shape: AnyView
    @State var size: CGFloat
    @State var color: Color
    @State var scale = 1.0
    @State var move = false

    var body: some View {
        shape
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .foregroundColor(color)
            .onAppear() {
                withAnimation(
                    Animation
                        .linear(duration: vm.explosionAnimationDuration)
                        .delay(vm.launchAnimDuration)
                        .repeatCount(1)
                ) {
                    scale = 0.0
                }
            }
    }
}
