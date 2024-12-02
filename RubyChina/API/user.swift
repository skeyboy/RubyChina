//
//  user.swift
//  RubyChina
//
//  Created by lee on 2024/11/30.
//

import Foundation

enum User {
    case users(limit: Int64)
    case user(id: Int64)
    case me
    case replies(id: Int64)
    case topics(id: Int64)
    case block(id: Int64)
    case unblock(id: Int64)
    case blocked(id: Int64)
    case follow(id: Int64)
    case unfollow(id: Int64)
    case following(id: Int64)
    case followers(id: Int64)
    case favorites(id: Int64)
}
