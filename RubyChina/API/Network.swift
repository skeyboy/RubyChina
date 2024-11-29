//
//  Network.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation
import Alamofire

class Network {
    static func fetch<Value: Decodable>(api:RCApi,_ type: Value.Type = Value.self)  async throws -> Value {
        
        return try await  api.asURLRequest()
            .serializingDecodable(Value.self)
    }
}
