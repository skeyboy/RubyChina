//
//  Preference.swift
//  RubyChina
//
//  Created by lee on 2024/12/2.
//

import Foundation

enum Preference : String, Identifiable {
    var id: String {
        self.rawValue
    }
    case dispayMode = "dispayMode"
}
