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
    @State var randomX = Double.random(in: -(UIScreen.main.bounds.size.width/2)...UIScreen.main.bounds.size.width/2)
    @State var randomY = Double.random(in: 100.0...UIScreen.main.bounds.size.height-100)
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View{
        ZStack{
            ForEach(0..<fireworkCenterVM.pieceCount, id:\.self){ i in
                FireworkFrame(fireworkCenterVM: fireworkCenterVM, index: i, launchHeight: randomY)
            }
        }
        .offset(x: location.x, y: location.y)
        .onAppear(){
            if firstAppear{
                withAnimation(Animation.timingCurve(0.075, 0.690, 0.330, 0.870, duration: fireworkCenterVM.launchAnimDuration).repeatCount(1)) {
                    location.x = randomX
                    location.y = -randomY
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + fireworkCenterVM.getAnimDuration()) {
                    //Clear
                    self.finishedAnimationCounter += 1
                }
                firstAppear = false
            }
        }
    }
}

struct FireworkFrame: View{
    //For Animation.timingCurve
    //https://matthewlein.com/tools/ceaser
    @StateObject var fireworkCenterVM: FireworkCenterVM
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    @State var index: Int
    @State var launchHeight: CGFloat
    
    var body: some View{
        FireworkItem(fireworkCenterVM: fireworkCenterVM, shape: getShape(), size: fireworkCenterVM.pieceSize)
            .offset(x: location.x, y: location.y)
            .onAppear(){
                withAnimation(Animation.timingCurve(0.1, 1.0, 0, 1, duration: getAnimationDuration()).delay(fireworkCenterVM.launchAnimDuration)) {
                    location.x = getDistance() * cos(deg2rad(getRandomAngle()))
                    location.y = -getDistance() * sin(deg2rad(getRandomAngle()))
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
    @State var scale = 1.0
    @State var move = false

    var body: some View {
        shape
            .frame(width: size, height: size)
            .scaleEffect(scale)
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
