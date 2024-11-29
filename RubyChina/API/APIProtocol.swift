//
//  APIProtocol.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import Foundation

import Alamofire


protocol APIProtocol {
    var path: String { get }
    var params: [String : Any] { get }
    var method: HTTPMethod? { get }
}
