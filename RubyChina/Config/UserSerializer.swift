//
//  UserSerializer.swift
//  RubyChina
//
//  Created by lee on 2024/11/28.
//

import Foundation

class UserSerializer : Decodable {
//    id [Integer] 用户编号
    var id: Int64
    
//    login [String] 用户名
    var login: String
    
//    name [String] 用户姓名
    var name: String
    
//    avatar_url [String] 头像 URL
    var avatar_url: String
    
    var abilities:Abilities?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case avatar_url
        case abilities
    }
}


class Abilities: Decodable {
    var update: Bool?
    var destroy: Bool?
    var ban: Bool?
    var normal: Bool?
    var excellent: Bool?
    var unexcellent: Bool?
    var close: Bool?
    var open: Bool?
}
