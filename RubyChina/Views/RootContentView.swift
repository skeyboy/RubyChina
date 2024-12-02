//
//  RootContentView.swift
//  RubyChina
//
//  Created by lee on 2024/12/2.
//

import SwiftUI

struct RootContentView: View {
    @EnvironmentObject var pathManager: PathManager
    var body: some View {
        
        NavigationStack(path: $pathManager.paths) {
            
            ZStack(alignment: .bottom) {
                TabView(selection: $pathManager.index) {
                    
                    HomeView().tag(TabItem.home).tabItem {
                        Text("Home")
                    }
                    MeView().tag(TabItem.me).tabItem {
                        Text("Me")
                    }
                    
                }.pathCustPageView { path in
                    path.someView()
                }
            }
        }.defaultView()
        
    }
}
#Preview {
    RootContentView()
}
