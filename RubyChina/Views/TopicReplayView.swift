//
//  TopicReplayView.swift
//  RubyChina
//
//  Created by lee on 2024/11/29.
//

import SwiftUI

@Observable
class TopicReplayViewModel {

    func replay(to id: Int64, body: String) {
       let replay = RCApi.Topic.reply(id: id, body: body)
    }
}

struct TopicReplayView: View {
    
    var topicId: Int64
    @State var viewModel: TopicListViewModel = .init()
    @Binding var isPresentedTopicReply: Bool
    @State var content: String = ""
    @State var discardConfirm: Bool = false
    @State var replyConfirm: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("discard").foregroundStyle(.red).onTapGesture {
                    discardConfirm = true
                }
                .confirmationDialog(
                    "Permanently erase the items in the Trash?",
                    isPresented: $discardConfirm
                ) {
                    Button("discard replay", role: .destructive) {
                        // Handle empty trash action.
                        isPresentedTopicReply = false
                    }
                }
                Spacer()
                Text("replay").foregroundStyle(.black)
                Spacer()
                Text("commit").onTapGesture {
                    replyConfirm = true
                }.bold()
                    .confirmationDialog(
                    "Permanently erase the items in the Trash?",
                    isPresented: $replyConfirm
                ) {
                    Button("commit replay", role: .destructive) {
                        // Handle empty trash action.
                        isPresentedTopicReply = !true
                    }
                }
            }
            .frame(minHeight: 45, maxHeight: 65)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
            GeometryReader { proxy in
                
                ScrollView(.vertical) {
                    TextEditor(text: $content)
                        .foregroundColor(Color.gray)
                        .font(.custom("HelveticaNeue", size: 13))
                        .lineSpacing(5).frame(width: proxy.size.width, height: proxy.size.height)
                    
                }.toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                        Text("放弃")
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                        Text("replay")
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Text("commit")
                    }
                    
                }
            }
        }
       
    }
}

#Preview {
    TopicReplayView(topicId: 43959, isPresentedTopicReply: .constant(true))
}
