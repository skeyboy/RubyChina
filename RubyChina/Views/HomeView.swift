//
//  HomeView.swift
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
    var offset: Int64 = 0
    var limit: Int64 = 0
    var node: NodeSerializer?
    init() {
        fetchTopic(nil)
    }
    
    func fetchTopic(_ sortType: RCApi.Topic.Sort? = .lastActived ,
                    _ offset: Int64 = 0,
                    _ limit: Int64 = 20,
                    node_id: Int64? = nil) {
        self.sortType = sortType ?? .lastActived
        let api = RCApi.topics(RCApi.Topic.list(sort: sortType, node_id: node_id ?? node?.id, offset: offset, limit: limit))
        Task { [weak self] in
            guard let self = self, let topic:Topic = try? await Network.fetch(api: api) else {
                return
            }
            self.topicMap[self.sortType] = topic
        }
    }
    
    func changeNode(_ node: NodeSerializer) {
        self.node = node
        fetchTopic(self.sortType, self.offset, self.limit, node_id: self.node?.id)
    }
    var currentTopic: Topic? {
        self.topicMap[self.sortType]
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var vm: TopicListViewModel = .init()
    @State var nodeId: Int = 0
    @State var node: NodeSerializer? = nil
    @State var showNode: Bool = false
    @EnvironmentObject var pathManager: PathManager
    var body: some View {
        
        GeometryReader { proxy in
            ScrollView(.vertical){
                    HStack {
                        Button {
                            showNode = true
                        } label: {
                            VStack {
                                Text("nodes")
                                if let node = node {
                                    Text(node.name)
                                }
                            }
                        }
                        ScrollView(.horizontal) {
                            Picker("", selection: $vm.sortType) {
                                ForEach( RCApi.Topic.Sort.allCases) { it in
                                    Text(LocalizedStringKey(it.rawValue))
                                }
                            }.pickerStyle(.segmented)
                        }
                        .padding(.leading,20)
                        .padding(.trailing, 20)
                        
                        
                    }
                    List{
                        
                        if let topic = vm.currentTopic {
                            
                            ForEach(topic.topics) { item in
                                HStack {
                                    if let url = item.user?.avatar_url, let imageURL = URL(string: url) {
                                        AvatorView(url: imageURL)
                                    }
                                    VStack(alignment: .leading){
                                        Text(item.title ?? "")
                                        TopicFooterView(topic: item)
                                    }
                                }.onTapGesture {
                                    pathManager.push(.detail(item.id))
                                }
                            }
                        }
                    }.edgesIgnoringSafeArea([.top])
                .frame(width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
            }
        }
       
        .sheet(isPresented: $showNode, content: {
            NodesView(currentNode: $node)
        }).edgesIgnoringSafeArea([.bottom])
            .onChange(of: vm.sortType) { oldValue, newValue in
                vm.fetchTopic(newValue)
            }.onChange(of: node, initial: false) { oldValue, newValue in
                if let node = node {
                    vm.changeNode(node)
                }
            }.onAppear {
                print("page on appear")
            }.defaultView()
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
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}
