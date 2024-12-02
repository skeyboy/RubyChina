//
//  TopicFooterView.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import SwiftUI

struct TopicFooterView: View {
    var topic: TopicSerializer
    var body: some View {
        HStack(alignment: .center,
               spacing: 0, content: {
            Text("\(topic.user?.login ?? "") * last replay by \(topic.last_reply_user_login ?? "") at").font(.system(size: 13))
            if let targetDate = topic.replied_at?.targetDate {
                Text(targetDate).font(.system(size: 13))
            }
        })
    }
}

#Preview {
    let json = """
{
            "id": 43962,
            "title": "elixir 还算是最像 ruby 的东西吗~是不是不太靠谱",
            "created_at": "2024-11-22T03:05:51.577Z",
            "updated_at": "2024-11-29T01:01:20.014Z",
            "replied_at": "2024-11-29T01:01:19.859Z",
            "replies_count": 3,
            "node_id": 1,
            "node_name": "Ruby",
            "last_reply_user_id": 36058,
            "last_reply_user_login": "hellorails",
            "grade": "normal",
            "likes_count": 0,
            "suggested_at": null,
            "closed_at": null,
            "deleted": false,
            "user": {
                "id": 6553,
                "login": "zzz6519003",
                "name": "Snowmanzzz",
                "avatar_url": "https://l.ruby-china.com/user/avatar/6553.jpg!large",
                "abilities": {
                    "update": false,
                    "destroy": false
                }
            },
            "excellent": 0,
            "hits": 305,
            "abilities": {
                "update": false,
                "destroy": false,
                "ban": false,
                "normal": false,
                "excellent": false,
                "unexcellent": false,
                "close": false,
                "open": false
            }
        }
"""
    var topic = try! JSONDecoder().decode(TopicSerializer.self, from: json.data(using: .utf8)!)
    TopicFooterView(topic: topic)
}
