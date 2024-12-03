//
//  TopicDetailView.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import SwiftUI
import MarkdownUI

@Observable
class TopicDetailViewModel {
    var topic: TopicDetail?
    
    init(){}
    
    func fetchTopic(topicId: Int64) {
        let api = RCApi.topics(RCApi.Topic.detail(id: topicId))
        
        Task { [weak self] in
            let topic:TopicDetail? = try? await Network.fetch(api: api)
            self?.topic = topic
        }
    }
}


struct TopicDetailView: View {
    var topicId: Int64
    @State private var viewModel: TopicDetailViewModel = .init()
    @State private var isPresentedTopicReply: Bool = false
    init(topicId: Int64) {
        self.topicId = topicId
        self.viewModel.fetchTopic(topicId: topicId)
    }
    
    var body: some View {
        if let topicDetail = viewModel.topic?.topic {
            
            VStack {
                HStack{
                    VStack(alignment: .leading, content: {
                        Text(topicDetail.title ?? "").font(.system(size: 20))
                        TopicDetailFooterView(topic: topicDetail)
                    })
                    Spacer()
                }.padding(.leading, 20)
                Divider()
                ScrollView {
                    Markdown(topicDetail.body ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.trailing, 20).onOpenURL { url in
                            print("打开链接")
                        }
                }
                Spacer()
            }.overlay(alignment: Alignment.bottom) {
                HStack{
                    Text("\(topicDetail.likes_count ?? 0 )个点赞")
                    Spacer()
                }.padding(.leading, 20)
            }.toolbar {
                ToolbarItem {
                    Button {
                        isPresentedTopicReply = true

                    } label: {
                        Text("replay")
                    }

                }
            }.sheet(isPresented: $isPresentedTopicReply) {
                
            } content: {
                TopicReplayView(topicId: topicId, isPresentedTopicReply: $isPresentedTopicReply)
            }.navigationTitle("Detail")

        } else {
            ProgressView()
        }
    }
    
    private struct TopicDetailFooterView : View {
        var topic: TopicDetailSerializer
        var body: some View {
            HStack{
                if let url = topic.user?.avatar_url, let avatarUrl = URL(string: url) {
                    AvatorView(url: avatarUrl)
                }
                ScrollView(.horizontal) {
                    Text("\(topic.user?.login ?? "") * last replay by \(topic.last_reply_user_login ?? "") at \(topic.replied_at?.targetDate ?? "")")
                        .font(.system(size: 13))
                }.scrollIndicators(ScrollIndicatorVisibility.hidden)
                VStack(alignment: .trailing, content: {
                    if let hits = topic.hits {
                        Text("\(hits) hits").font(.system(size: 10))
                        if let likes_count = topic.likes_count , likes_count > 0{
                            Text("\(likes_count) like").font(.system(size: 10))
                        }
                        
                    }
                })
                
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        TopicDetailView(topicId: 43959)
    }
}
