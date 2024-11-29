//
//  AvatorView.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import SwiftUI
import Kingfisher

struct AvatorView: View {
    var url: URL
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
                .scaledToFit()
                .cornerRadius(50)
                .frame(width: 50, height: 50)
                .overlay(Circle().stroke(lineWidth: 1/UIScreen.main.scale))
                .foregroundColor(Color.blue)
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    AvatorView(url: URL(string: "https://ruby-china.org/system/letter_avatars/g.png")!)
}
