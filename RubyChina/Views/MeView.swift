//
//  MeView.swift
//  RubyChina
//
//  Created by lee on 2024/12/2.
//

import SwiftUI

struct MeView: View {
    @EnvironmentObject var pathManager: PathManager
    var body: some View {
        ScrollView(.vertical) {
            Text("Hello, World!")
            AppearanceView()
            Browser(url: URL(string: "https://www.baidu.com")!).frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
        }.defaultView()
    }
}

#Preview {
    MeView()
}
