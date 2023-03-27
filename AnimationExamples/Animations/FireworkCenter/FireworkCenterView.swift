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
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .background(Color.black)
            .ignoresSafeArea()
    }
}

struct FireworkView: View{
    
    @Binding var counter: Int
    @StateObject var fireworkCenterVM = FireworkCenterVM()
    @State var animate = 0
    @State var finishedAnimationCounter = 0
    @State var firstAppear = false
    
    var body: some View{
        ZStack{
            ForEach(finishedAnimationCounter..<animate, id:\.self){ i in
                FireworkContainer(
                    fireworkCenterVM: fireworkCenterVM,
                    finishedAnimationCounter: $finishedAnimationCounter
                )
            }
        }
        .onAppear(){
            firstAppear = true
        }
        .onChange(of: counter){value in
            if firstAppear{
                for i in 0...fireworkCenterVM.repetitions{
                    DispatchQueue.main.asyncAfter(deadline: .now() + fireworkCenterVM.repetitionInterval * Double(i)) {
                        animate += 1
                    }
                }
            }
        }
    }
}

struct FireworkContainer: View {
    
    @StateObject var fireworkCenterVM: FireworkCenterVM
    @Binding var finishedAnimationCounter:Int
    @State var firstAppear = true
    @State var randomX = Double.random(in: -100...100)
    @State var randomY = Double.random(in: 200.0...UIScreen.main.bounds.size.height-200)
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View{
        ZStack{
            ForEach(0..<fireworkCenterVM.pieceCount, id:\.self){ i in
                FireworkFrame(fireworkCenterVM: fireworkCenterVM, index: i, launchHeight: randomY, color: getColor())
            }
        }
        .offset(x: location.x, y: location.y)
        .onAppear(){
            if firstAppear{
                withAnimation(Animation.timingCurve(0.075, 0.690, 0.330, 0.870, duration: fireworkCenterVM.launchAnimDuration).repeatCount(1)) {
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
        return fireworkCenterVM.explosionAnimationDuration + fireworkCenterVM.launchAnimDuration
    }
    func getColor() -> Color{
        return fireworkCenterVM.colors.randomElement()!
    }
}

struct FireworkFrame: View{

    @StateObject var fireworkCenterVM: FireworkCenterVM
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    @State var index: Int
    @State var launchHeight: CGFloat
    @State var percentage: CGFloat = 0.0
    @State var strokeWidth: CGFloat = 2.0
    @State var color: Color
    
    var body: some View{
        ZStack{
            FireworkItem(fireworkCenterVM: fireworkCenterVM, shape: getShape(), size: fireworkCenterVM.pieceSize, color: color)
                .offset(x: location.x, y: location.y)
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: location.x, y: location.y))
            }.trim(from: 0.0, to: percentage)
                .stroke(color, lineWidth: strokeWidth)
                .frame(width: 1.0, height: 1.0)
        }.onAppear(){
            withAnimation(
                Animation.timingCurve(0.0, 1.0, 1.0, 1.0, duration: getAnimationDuration())
                    .delay(fireworkCenterVM.launchAnimDuration).repeatCount(1)
            ){
                location.x = getDistance() * cos(deg2rad(getRandomAngle()))
                location.y = -getDistance() * sin(deg2rad(getRandomAngle()))
                percentage = 1.0
                strokeWidth = 0.0
            }
        }
    }
    func getRandomAngle() -> CGFloat{
        return (360.0 / Double(fireworkCenterVM.pieceCount)) * Double(index)
    }
    func getShape() -> AnyView {
        return fireworkCenterVM.getShapes().randomElement()!
    }
    func getRandomExplosionTimeVariation() -> CGFloat {
        return CGFloat((0...999).randomElement()!) / 2100
    }
    func getAnimationDuration() -> CGFloat {
        return fireworkCenterVM.explosionAnimationDuration + getRandomExplosionTimeVariation()
    }
    func getDistance() -> CGFloat {
        return fireworkCenterVM.radius + (launchHeight / 10)
    }
    func getDelayBeforeDropAnimation() -> TimeInterval {
        return fireworkCenterVM.explosionAnimationDuration *  0.1
    }
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * CGFloat.pi / 180
    }
}

struct FireworkItem: View {
    
    @StateObject var fireworkCenterVM: FireworkCenterVM
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
                        .linear(duration: fireworkCenterVM.explosionAnimationDuration)
                        .delay(fireworkCenterVM.launchAnimDuration)
                        .repeatCount(1)
                ) {
                    scale = 0.0
                }
            }
    }
}
