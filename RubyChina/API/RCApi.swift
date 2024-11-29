//
//  RCApi.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation
import Alamofire


enum RCApi {
    case topics(Topic)
    
    case replies(Replies)
}


extension RCApi {
    enum Method : String {
        typealias RawValue = String
        case get = "GET"
        case post = "POST"
    }
}

extension RCApi {
    static let baseUrl: String = "https://ruby-china.org"
    var path: String {
        switch self {
        case .replies(let replay):
            return replay.path
        case .topics(let topic):
            return topic.path
        }
    }
    
    var url: String {
        RCApi.baseUrl+self.path
    }
    
}

extension RCApi: APIProtocol {
    var params: [String : Any] {
        switch self {
        case .topics(let topic):
            return topic.params
        case .replies(let replies):
            return replies.params
        }
    }
    
    var method: Alamofire.HTTPMethod? {
        switch self {
        case .topics(let topic):
            return topic.method
        case .replies(let replies):
            return replies.method
        }
    }

    
}
extension Alamofire.DataRequest {
    
    func serializingDecodable<Value: Decodable>(_ type: Value.Type = Value.self) async throws -> Value {
        let result = await serializingData().result
        switch result {
        case .success(let data):
            do {
                return try JSONDecoder().decode(Value.self, from: data)
            } catch let error {
                throw error
            }
            
        case .failure(let error):
            throw error
        }
    }
}

extension RCApi {
    func asURLRequest() throws -> DataRequest {
        AF.request(self.url,
                   method: self.method ?? .get,
                   parameters: self.params, encoding: URLEncoding.default)
    }
}
