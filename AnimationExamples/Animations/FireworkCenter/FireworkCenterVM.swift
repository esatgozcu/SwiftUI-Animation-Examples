//
//  FireworkCenterVM.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/26.
//

import SwiftUI

/// - Parameters:
///  - pieceCount: amount of confetti
///  - colors: list of colors that is applied to the default shapes
///  - pieceSize: size that confetti and emojis are scaled to
///  - radius: explosion radius
///  - repetitions: number of repetitions of the explosion
///  - repetitionInterval: duration between the repetitions
class FireworkCenterVM: ObservableObject{
    @Published var pieceCount: Int
    @Published var pieceType: [FireworkType]
    @Published var colors: [Color]
    @Published var pieceSize: CGFloat
    @Published var radius: CGFloat
    @Published var repetitions: Int
    @Published var repetitionInterval: Double
    @Published var explosionAnimationDuration: Double
    @Published var launchAnimDuration: Double

    init(pieceCount: Int = 20,
         pieceType: [FireworkType] = [.shape(.circle)],
         colors: [Color] = [
            Color.init(hex: "f88f22"),
            Color.init(hex: "9c1d08"),
            Color.init(hex: "ce7117"),
            Color.init(hex: "f24d24"),
            Color.init(hex: "113bc6"),
            Color.init(hex: "c54a85"),
            Color.init(hex: "92af96"),
            Color.init(hex: "d23508")
         ],
         pieceSize: CGFloat = 10.0,
         radius: CGFloat = 100,
         repetitions: Int = 15,
         repetitionInterval: Double = 0.5,
         explosionAnimDuration: Double = 1.2,
         launchAnimDuration: Double = 3.0
    ) {
        self.pieceCount = pieceCount
        self.pieceType = pieceType
        self.colors = colors
        self.pieceSize = pieceSize
        self.radius = radius
        self.repetitions = repetitions
        self.repetitionInterval = repetitionInterval
        self.explosionAnimationDuration = explosionAnimDuration
        self.launchAnimDuration = launchAnimDuration
    }
    func getShapes() -> [AnyView]{
        var shapes = [AnyView]()
        for firework in pieceType{
            switch firework {
            case .shape(_):
                shapes.append(AnyView(firework.view.frame(width: pieceSize, height: pieceSize, alignment: .center)))
            default:
                shapes.append(AnyView(firework.view.font(.system(size: pieceSize))))
            }
        }
        return shapes
    }
}

public enum FireworkType: CaseIterable, Hashable {
    public enum Shape {
        case circle
        case triangle
        case square
        case slimRectangle
        case roundedCross
    }
    
    case shape(Shape)
    case text(String)
    case sfSymbol(symbolName: String)
    
    public var view:AnyView{
        switch self {
        case .shape(.square):
            return AnyView(Rectangle())
        case .shape(.circle):
            return AnyView(Circle())
        case .shape(.triangle):
            return AnyView(Triangle())
        case .shape(.slimRectangle):
            return AnyView(SlimRectangle())
        case .shape(.roundedCross):
            return AnyView(RoundedCross())
        case let .text(text):
            return AnyView(Text(text))
        case .sfSymbol(let symbolName):
            return AnyView(Image(systemName: symbolName))
        }
    }
    public static var allCases: [FireworkType] {
        return [.shape(.circle), .shape(.triangle), .shape(.square), .shape(.slimRectangle), .shape(.roundedCross)]
    }
}
