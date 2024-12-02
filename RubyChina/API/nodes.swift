//
//  nodes.swift
//  RubyChina
//
//  Created by lee on 2024/11/30.
//

import Foundation
import Alamofire

extension RCApi {
    enum Nodes {
        case nodes
        case detail(id: Int64)
    }
}

extension RCApi.Nodes : APIProtocol {
    var path: String {
        switch self {
        case .nodes:
            return "/api/v3/nodes"
        case .detail(let id):
            return "/api/v3/nodes/\(id)"
        }
    }
    
    var params: [String : Any] {
        [:]
    }
    
    var method: Alamofire.HTTPMethod? {
        .get
    }
    
    
}
