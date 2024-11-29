//
//  ContentView.swift
//  RubyChina
//
//  Created by lee on 2024/11/28.
//

import SwiftUI
import SwiftData

@Observable
class TopicListViewModel {
    var topicMap: [RCApi.Topic.Sort: Topic] = [:]
    var sortType: RCApi.Topic.Sort = .lastActived
    
    init() {
        fetchTopic(nil)
    }
    
    func fetchTopic(_ sortType: RCApi.Topic.Sort? = .lastActived , _ offset: Int64 = 0, _ limit: Int64 = 20, _ node_id: Int64? = nil) {
        if self.sortType == sortType {
            return
        }
        self.sortType = sortType ?? .lastActived
        let api = RCApi.topics(RCApi.Topic.list(sort: sortType, node_id: node_id, offset: offset, limit: limit))
        Task { [weak self] in
            guard let self = self, let topic:Topic = try? await Network.fetch(api: api) else {
                return
            }
            self.topicMap[self.sortType] = topic
        }
    }
    var currentTopic: Topic? {
        self.topicMap[self.sortType]
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var vm: TopicListViewModel = .init()
    var body: some View {
        NavigationSplitView {
            ScrollView(.horizontal) {
                Picker("", selection: $vm.sortType) {
                    ForEach( RCApi.Topic.Sort.allCases) { it in
                        Text(it.rawValue)
                    }
                }.pickerStyle(.segmented)
            }
            .padding(.leading,20)
            .padding(.trailing, 20)
            
            List{
                
                if let topic = vm.currentTopic {
                    
                    ForEach(topic.topics) { item in
                        NavigationLink {
                            TopicDetailView(topicId: item.id)
                        } label: {
                            HStack {
                                if let url = item.user?.avatar_url, let imageURL = URL(string: url) {
                                    AvatorView(url: imageURL)
                                }
                                
                                VStack(alignment: .leading){
                                    Text(item.title ?? "")
                                    TopicFooterView(topic: item)
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            
        } detail: {
            Text("Select an item")
        }
        .edgesIgnoringSafeArea([.bottom,.top])
        .onChange(of: vm.sortType) { oldValue, newValue in
            vm.fetchTopic(newValue)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
