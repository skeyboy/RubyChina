//
//  View+Ext.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation
import SwiftUI

private struct SafeAreaInsetsKey: PreferenceKey {
    static var defaultValue = EdgeInsets()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

extension View {
    func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
            }
            .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                safeInsets.wrappedValue = value
            }
        )
    }
    
    func printSafeAreaInsets(id: String) -> some View {
            background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
                }
                .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                    print("\(id) insets:\(value)")
                }
            )
        }
}



extension View {
    func defaultView() -> some View {
        self.navigationDestination(for: RCNavigationPath.self) { path in
            print(path)
            return path.someView()
        }
    }
    
    func pathCustPageView(@ViewBuilder destionation: @escaping (_ path: RCNavigationPath) -> some View) -> some View {
        self.navigationDestination(for: RCNavigationPath.self, destination: destionation)
    }
}

