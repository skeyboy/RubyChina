//
//  AppRootView.swift
//  RubyChina
//
//  Created by lee on 2024/12/2.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var pathManager: PathManager
    var body: some View {
        RootContentView()
            .environment(\.openURL, OpenURLAction(handler: { url in
                pathManager.push(.browser(URL(string:"https://www.baidu.com")!))
            return .handled
        }))
    }
}


#Preview {
    AppRootView()
}
