//
//  NodeSerializer.swift
//  RubyChina
//
//  Created by lee on 2024/11/30.
//

import Foundation

    /**
     {
                "id": 28,
                "name": "其他",
                "topics_count": 415,
                "summary": "无法确定的东西，发在这里。",
                "sort": -999,
                "updated_at": "2015-03-01T14:35:21.784Z",
                "section_id": 1,
                "section_name": "Nodes"
            }
     */
    
class Nodes : Decodable {
    var nodes: [NodeSerializer]
}

// MARK: - NodeSerializer
struct NodeSerializer: Decodable , Identifiable, Equatable {
    var id: Int64 = 0
    let name: String
    let topicsCount: Int
    let summary: String
    let sort: Int
    let updatedAt: String
    let sectionID: Int
    let sectionName: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case topicsCount = "topics_count"
        case summary, sort
        case updatedAt = "updated_at"
        case sectionID = "section_id"
        case sectionName = "section_name"
    }
}
