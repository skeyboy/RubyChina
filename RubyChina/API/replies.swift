//
//  replies.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation
import Alamofire
extension RCApi {
    enum Replies {
        /**
         获取回帖的详细内容
         
         获取回帖的详细内容（一般用于编辑回帖的时候）
         
         GET /api/v3/replies/:id
         Response
         
         ReplyDetailSerializer
         */
        case detail(Int64)
        
        /**
         修改回帖
         
         POST /api/v3/replies/:id
         
         Parameters
         
         body (String) - 回帖内容 [required]
         */
        case modify(_ id: Int64, _ body:String)
        /**
         删除回帖
         
         DELETE /api/v3/replies/:id
         */
        case delete(Int64)
        
    }
}

extension RCApi.Replies : APIProtocol {}

extension RCApi.Replies {
    var path: String {
        switch self {
        case .detail(let id):
            return "/api/v3/replies/\(id)"
        case .modify(let id, _):
            return "/api/v3/replies/\(id)"
        case .delete(let id):
            return "/api/v3/replies/\(id)"
        }
    }
    
    var params: [String : Any] {
        switch  self {
        case .detail, .delete:
            return [:]
        case .modify(_, let body):
            return ["body": body]
        }
    }
    
    var method: HTTPMethod? {
        switch self {
        case .detail:
            return .get
        case .modify:
            return .post
        case .delete:
            return .delete
        }
    }
}


