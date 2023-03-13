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
                HomePageItem(title: "Snow Flake", image: "snow_flake") {
                    SnowFlakeView()
                }
                HomePageItem(title: "Paper Plane", image: "paper_plane") {
                    PaperPlaneView()
                }
            }
            .padding()
        }
    }
}

struct HomePageItem<Content: View>: View {
    
    var title : String
    var image : String
    var content: () -> Content
    
    var body: some View {
        NavigationLink(destination: content) {
            Text(title)
            Image(image)
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
