//
//  ContentView.swift
//  AnimationExamples
//
//  Created by Esat Gözcü on 2023/03/13.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: SnowFlakeView()) {
                    Text("Snow Flake")
                }
                NavigationLink(destination: PaperPlaneView()) {
                    Text("Paper Plane")
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
