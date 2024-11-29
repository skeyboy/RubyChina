//
//  TopicDetailSerializer.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation

class TopicDetail : Decodable {
    var topic: TopicDetailSerializer
    var meta: Meta?
}

class Meta : Decodable {
    var followed: Bool?
    var liked: Bool?
    var favorited: Bool?
}
class TopicDetailSerializer: Decodable , Identifiable {
    typealias ID = Int64
//    id [Integer] 话题编号
    var id: Int64 = 0
    
//    title [String] 标题
    var title: String?
    
//    node_name [String] 节点名称
    var node_name: String?
    
//    node_id [Integer] 节点 ID
    var node_id: Int64?
    
    
    var suggested_at: String?
    var closed_at: String?
//    excellent [Boolean] 是否精华
    var excellent: Int64?
    
//    deleted [Boolean] 是否已删除
    var deleted: Bool?
    
//    replies_count [Integer] 回帖数量
    var replies_count: Int64?
    
//    likes_count [Integer] 赞数量
    var likes_count: Int64?
    
//    *last_reply_user_id*/ [Integer] 最后回复人用户编号
    var last_reply_user_id: Int64?
    
//    *last_reply_user_login*/ [String] 最后回复者 login
    var last_reply_user_login: String?
    
//    user UserSerializer 最后回复者用户对象
    var user: UserSerializer?
    
//    *replied_at*/ [DateTime] 最后回帖时间
    var  replied_at: String?
    
//    *created_at*/ [DateTime] 创建时间
    var created_at: String?
    
//    *updated_at*/ [DateTime] 更新时间
    var updated_at: String?
    
    var grade: String?
    
    var body: String?
    var body_html: String?
    var hits: Int64?
    var abilities: Abilities?

    enum CodingKeys: String, CodingKey {
        case id
        case node_name
        case title
        case excellent
        case node_id
        case deleted
        case replies_count
        case likes_count
        case last_reply_user_id
        case last_reply_user_login
        case user
        case replied_at
        case created_at
        case updated_at
        case grade
        case body
        case body_html
        case hits
        case abilities
        case closed_at
        case suggested_at
    }
}
