//
//  String+Ext.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation
import SwiftUI
extension String {
    
    var targetDate: String {
        // 指定时间字符串
        let targetTimeString = self
        
        // 将字符串格式的时间转换为 Date 对象
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let targetDate = dateFormatter.date(from: targetTimeString) {
            // 获取当前时间
            let currentDate = Date()
            
            // 计算时间差值（以秒为单位）
            let timeInterval = currentDate.timeIntervalSince(targetDate)
            
            // 根据时间差值返回相应的描述
            if abs(timeInterval) < 3600 { // 1小时
                return "just now"
            } else if abs(timeInterval) < 86400 { // 24小时
                let hours = Int(abs(timeInterval / 3600))

                return "\(hours) hours ago"
            } else {
                let days = Int(abs(timeInterval / 86400))
                return "\(days) days ago"
            }
        }
        return ""
    }
}
