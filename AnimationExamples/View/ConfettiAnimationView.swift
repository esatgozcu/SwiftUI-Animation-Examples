//
//  ConfettiView.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/17.
//

import SwiftUI

struct ConfettiAnimationView: View{
    
    @State var counter = 0
    
    var body: some View{
        ZStack{
            Text("🎉").onTapGesture {
                counter += 1
            }
            ConfettiView(counter: $counter)
            //ConfettiView(counter: $counter, confettiVM: ConfettiVM(confettiNumber: 10, repetitions: 4))
            //ConfettiView(counter: $counter, confettiVM: ConfettiVM(confettiNumber: 50, repetitions: 5))
            //ConfettiView(counter: $counter, confettiVM: ConfettiVM(confettiNumber: 50, radius: 600, repetitions: 5))
            //ConfettiView(counter: $counter, confettiVM: ConfettiVM(openingAngle: Angle(degrees: 0), closingAngle: Angle.degrees(360)))
        }
    }
}

struct ConfettiView: View{
    
    @Binding var counter: Int
    @StateObject var confettiVM = ConfettiVM()
    @State var animate = 0
    @State var finishedAnimationCounter = 0
    @State var firstAppear = false
    
    var body: some View{
        ZStack{
            ForEach(finishedAnimationCounter..<animate, id:\.self){ i in
                ConfettiContainer(
                    confettiVM: confettiVM, finishedAnimationCounter: $finishedAnimationCounter
                )
            }
        }
        .onAppear(){
            firstAppear = true
        }
        .onChange(of: counter){value in
            if firstAppear{
                for i in 0...confettiVM.repetitions{
                    DispatchQueue.main.asyncAfter(deadline: .now() + confettiVM.repetitionInterval * Double(i)) {
                        animate += 1
                    }
                }
            }
        }
    }
}

struct ConfettiContainer: View {
    
    @StateObject var confettiVM: ConfettiVM
    @Binding var finishedAnimationCounter:Int
    @State var firstAppear = true

    var body: some View{
        ZStack{
            ForEach(0..<confettiVM.confettiNumber, id:\.self){_ in
                ConfettiFrame(confettiVM: confettiVM)
            }
        }
        .onAppear(){
            if firstAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + confettiVM.getAnimDuration()) {
                    self.finishedAnimationCounter += 1
                }
                firstAppear = false
            }
        }
    }
}

struct ConfettiFrame: View{
    //For Animation.timingCurve
    //https://matthewlein.com/tools/ceaser
    @StateObject var confettiVM: ConfettiVM
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    @State var opacity: Double = 0.0

    var body: some View{
        ConfettiItem(shape: getShape(), color: getColor())
            .offset(x: location.x, y: location.y)
            .opacity(opacity)
            .onAppear(){
                withAnimation(Animation.timingCurve(0.1, 1.0, 0, 1, duration: getAnimationDuration())) {
                
                    opacity = confettiVM.opacity
                    
                    let randomAngle:CGFloat
                    if confettiVM.openingAngle.degrees <= confettiVM.closingAngle.degrees{
                        randomAngle = CGFloat.random(in: CGFloat(confettiVM.openingAngle.degrees)...CGFloat(confettiVM.closingAngle.degrees))
                    }else{
                        randomAngle = CGFloat.random(in: CGFloat(confettiVM.openingAngle.degrees)...CGFloat(confettiVM.closingAngle.degrees + 360)).truncatingRemainder(dividingBy: 360)
                    }
                    
                    let distance = getDistance()
                    
                    location.x = distance * cos(deg2rad(randomAngle))
                    location.y = -distance * sin(deg2rad(randomAngle))
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + getDelayBeforeRainAnimation()) {
                    withAnimation(Animation.timingCurve(0.12, 0, 0.39, 0, duration: confettiVM.dropAnimationDuration)) {
                        location.y += confettiVM.dropHeight
                        opacity = confettiVM.fadesOut ? 0 : confettiVM.opacity
                    }
                }
            }
    }
    func getShape() -> AnyView {
        return confettiVM.getShapes().randomElement()!
    }
    func getColor() -> Color {
        return confettiVM.colors.randomElement()!
    }
    func getRandomExplosionTimeVariation() -> CGFloat {
        return CGFloat((0...999).randomElement()!) / 2100
    }
    func getAnimationDuration() -> CGFloat {
        return 0.2 + confettiVM.explosionAnimationDuration + getRandomExplosionTimeVariation()
    }
    func getDistance() -> CGFloat {
        return pow(CGFloat.random(in: 0.01...1), 2.0/7.0) * confettiVM.radius
    }
    func getDelayBeforeRainAnimation() -> TimeInterval {
        confettiVM.explosionAnimationDuration *  0.1
    }
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * CGFloat.pi / 180
    }
}

struct ConfettiItem: View {
    
    @State var shape: AnyView
    @State var color: Color
    
    @State var move = false
    @State var anchor = CGFloat(Int.random(in: 0...1))
    @State var spinDirX = [-1.0, 1.0].randomElement()!
    @State var spinDirZ = [-1.0, 1.0].randomElement()!
    @State var xSpeed = Double.random(in: 0.501...2.201)
    @State var zSpeed = Double.random(in: 0.501...2.201)
    
    var body: some View {
        shape
            .foregroundColor(color)
            .rotation3DEffect(.degrees(move ? 360:0), axis: (x: spinDirX, y: 0, z: 0))
            .animation(Animation.linear(duration: xSpeed).repeatForever(), value: move)
            .rotation3DEffect(.degrees(move ? 360:0), axis: (x: 0, y: 0, z: spinDirZ), anchor: UnitPoint(x: anchor, y: anchor))
            .animation(Animation.linear(duration: zSpeed).repeatForever(), value: move)
            .onAppear() {
                move = true
            }
    }
}
