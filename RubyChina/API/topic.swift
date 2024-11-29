//
//  topi.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation
import Alamofire

extension RCApi {
    enum Topic {
        /**
         type (String) — 动作类型，ban - 屏蔽话题，excellent - 加精华，unexcellent - 去掉精华，close - 关闭回复，open - 开启回复
         */
        enum Action : String {
            typealias RawValue = String
            case ban = "ban"
            case excellent = "excellent"
            case unexcellent = "unexcellent"
            case close = "close"
            case open = "open"
        }
        
        enum Sort : String , Codable, CaseIterable , Identifiable {
            typealias RawValue = String
                        case lastActived = "last_actived"
            case recent = "recent"
            case noReply = "no_reply"
            case popular = "popular"
            case excellent = "excellent"
            var id: Sort  { self}
        }
        /**
         获取话题列表

         获取话题列表，类似 Ruby China 话题列表的内容，支持多种排序方式。

         GET /api/v3/topics
         
         Parameters:

         type (String) - 排序类型，default: last_actived
         可选值：last_actived, recent, no_reply, popular, excellent
         node_id (Integer) - 节点编号，如果有给，就会只去节点下的话题
         offset (Integer) - default: 0
         limit (Integer) - default: 20, range: 1..150

         */
        case list(sort: Topic.Sort? = .lastActived, node_id: Int64?, offset:Int64 = 0, limit: Int64 = 20 )
        /**
         话题详情

         获取话题详情（不含回帖）

         GET /api/v3/topics/:id
         */
        case detail(id: Int64)
        
        /**
         创建新话题

         创建一篇新的话题


         POST /api/v3/topics
         Parameters:

         title (String) — 标题，[required]
         node_id (Integer) — 节点编号，[required]
         body (Markdown) — 格式的正文，[required]
         */
        case create(title: String, node_id: Int64, body: String)
        
        /**
         修改话题

         修改话题内容


         PUT /api/v3/topics/:id
         Parameters

         title (String) — 标题，[required]
         node_id (Integer) — 节点编号，[required]
         body (Markdown) — 格式的正文，[required]

         */
        case modify(id:Int64, title: String, node_id: Int64, body: String)
        
        /**
         删除话题

         删除一篇话题

         DELETE /api/v3/topics/:id

         */
        case delete(id: Int64)
        
        /**
         创建回帖

         创建对 :id 话题的回帖

         POST /api/v3/topics/:id/replies
         Parameters

         body (String) - 回帖正文
         */
        case reply(id: Int64, body: String)
        
        /**
         话题的回帖列表

         获取话题的回帖列表

         GET /api/v3/topics/:id/replies

         */
        case replies(id: Int64, offset: Int64, limit: Int64)
        
        /**
         关注话题

         POST /api/v3/topics/:id/follow
         */
        case follow(id: Int64)
        
        /**
         取消关注话题

         POST /api/v3/topics/:id/unfollow
         */
        case unfollow(id: Int64)
        
        /**
         收藏话题

         POST /api/v3/topics/:id/favorite

         */
        case favorite(id: Int64)
        
        /**
         取消收藏话题

         POST /api/v3/topics/:id/unfavorite
         */
        case unfavorite(id: Int64)
        
        /**
         话题动作接口

         对 :id 这篇话题发起动作（屏蔽、加精华、结束讨论...）注意类型有不同的权限，详见 GET /api/v3/topics/:id 返回的 abilities

         POST /api/v3/topics/:id/action?type=:type
         Parameters:

         type (String) — 动作类型，ban - 屏蔽话题，excellent - 加精华，unexcellent - 去掉精华，close - 关闭回复，open - 开启回复
         */
        case action(id: Int64, actionType: Topic.Action)
        
    }
}

extension RCApi.Topic : APIProtocol {
    var path: String {
        switch self {
        case .list:
            return "/api/v3/topics"
        case .detail(let id):
            return "/api/v3/topics/\(id)"
        case .create:
            return "/api/v3/topics"
        case .modify(let id,_, _, _):
            return "/api/v3/topics/\(id)"
        case .delete(let id):
            return "/api/v3/topics/\(id)"
        case .reply(let id, _):
            return "/api/v3/topics/\(id)/replies"
        case .replies(let id, _, _):
            return "/api/v3/topics/\(id)/replies"
        case .follow(let id):
            return "/api/v3/topics/\(id)/follow"
        case .unfollow(let id):
            return "/api/v3/topics/\(id)/unfollow"
        case .favorite(let id):
            return "/api/v3/topics/\(id)/favorite"
        case .unfavorite(let id):
            return "/api/v3/topics/\(id)/unfavorite"
        case .action(let id, let actionType):
            return "/api/v3/topics/\(id)/action?type=\(actionType.rawValue)"
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .detail, .delete, .follow, .unfavorite, .action, .unfollow, .favorite:
            return [:]
        case .list(let sort, let node_id, let offset, let limit):
            var parmas: [String: AnyHashable] = [:]
            if let sort = sort {
                parmas["type"] = sort.rawValue
            }
            if let node_id = node_id {
                parmas["node_id"] = node_id
            }
            parmas["offset"] = offset
            parmas["limit"] = limit
            return parmas
            
        case .create(let title, let node_id, let body):
            return ["title":title,"node_id": node_id, "body":body]
        case .modify(_, let title, let node_id, let body):
            return ["title":title,"node_id": node_id, "body":body]
        case .reply(_, let body):
            return ["body":body]
        case .replies(_, let offset, let limit):
            return ["offset": offset, "limit":limit]
        }
    }
    
    var method: Alamofire.HTTPMethod? {
        switch self {
        case .list, .detail, .replies:
            return .get
        case .create, .reply, .follow, .unfollow, .favorite, .unfavorite, .action:
            return .post
        case .modify:
            return .put
        case .delete:
            return .delete
        }
    }
}
