//
//  AppearanceView.swift
//  RubyChina
//
//  Created by lee on 2024/12/1.
//

import SwiftUI

struct AppearanceView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var pathManager: PathManager

    var body: some View {
        ChildView(color:$pathManager.color).preferredColorScheme(pathManager.color)
    }
}

struct ChildView : View {
    @Binding var color: ColorScheme?
    @State  private var isPresented = false
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode = true
    @AppStorage(Preference.dispayMode.rawValue) private var withSystem: Bool = false
    var body: some View {
        ScrollView{
            Text("Hello, World! The color is \(colorScheme)").preferredColorScheme(color)
            Toggle("Withn System", isOn: $withSystem)
            Toggle("Dark Mode", isOn: $isDarkMode)
                .disabled(withSystem)
        }.onChange(of: isDarkMode) { oldValue, newValue in
            if isDarkMode {
                color = .dark
            } else {
                color = .light
            }
        }.onAppear {
            isDarkMode = color == .dark
            
        }.onChange(of: withSystem) { oldValue, newValue in
            if newValue {
                color = nil
            } else {
                if isDarkMode {
                    color = .dark
                } else {
                    color = .light
                }
            }
           
            
        }
    }
}

#Preview {
    AppearanceView().environmentObject(PathManager.manager)
}

enum Sort :String, EnvironmentKey {
    case am = "am"
    case pm = "pm"
    static var defaultValue: Sort = .am
    typealias RawValue = String
    typealias Value = Sort
}

extension EnvironmentValues {
    var sort: Sort {
        get {
            self[Sort.self]
        }
        set {
            self[Sort.self] = newValue
        }
    }
}



struct SortView: View {
    var preferValue: PreferValue = PreferValue.shared
    @Environment(\.sort) private var sort: Sort
    var body: some View {
        Text("自定义实现Environment数据注入: \(sort)")
    }
}

class PreferValue : ObservableObject {
    static let shared: PreferValue = .init()
      init() {
        
    }
}
#Preview("Sort", body: {
    var preferValue: PreferValue = .shared
    SortView().environment(\.sort, .am)
        .environmentObject(preferValue)
})

