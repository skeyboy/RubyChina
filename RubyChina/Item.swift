//
//  Item.swift
//  RubyChina
//
//  Created by lee on 2024/11/28.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
