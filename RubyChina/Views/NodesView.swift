//
//  NodesView.swift
//  RubyChina
//
//  Created by lee on 2024/11/30.
//

import SwiftUI

@Observable
class NodesViewModel {
    var nodes: [NodeSerializer] = []
    func fetch()  {
        Task {
            let api = RCApi.nodes(RCApi.Nodes.nodes)
            if let  node: Nodes? = try? await Network.fetch(api: api), let nodes = node?.nodes {
                self.nodes = nodes
            }
        }
    }
}
struct NodesView: View {
    @State var selection: [NodeSerializer] = []
    @State private var viewModel: NodesViewModel = .init()
    @Binding var currentNode: NodeSerializer?
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.nodes) { node in
                    HStack {
                        VStack(alignment: .leading, content: {
                            Text(node.name).font(.title)
                            Text(node.summary).font(.title3)
                        })
                        Spacer()
                    }.onTapGesture {
                        currentNode = node
                        presentationMode.wrappedValue.dismiss()
                    }
                    Divider()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }.onAppear {
                viewModel.fetch()
            }
        }
        
    }
}

#Preview {
    NodesView(currentNode: .constant(nil))
}
