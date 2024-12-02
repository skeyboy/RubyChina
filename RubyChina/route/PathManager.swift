//
//  PathManager.swift
//  RubyChina
//
//  Created by lee on 2024/12/2.
//

import Foundation
import SwiftUI
import Alamofire

protocol RCNavigationPathProtocol {
    associatedtype View: SwiftUI.View
    func defaultView() -> View
    func pathCustPageView(@ViewBuilder destionation: @escaping (_ path: RCNavigationPath) -> View) -> View
}
enum TabItem : Int {
    case home = 0
    case me = 1
}

enum RCNavigationPath : Hashable {
    case me
    case home(_ index: TabItem)
    case detail(_ id: Int64)
    case browser(_ url: URL)
    
    func someView()-> some View {
        
        switch self {
        case .browser(let url):
            
            return BrowserView(url: url).defaultView()
            
        case .detail(let id):
            return TopicDetailView(topicId: id)
        case .home(_):
            return HomeView()//.environmentObject(PathManager.manager)
        case .me:
            return MeView()
        }
    }
}

protocol RCNavigationProtocol {
    func push(_ path: RCNavigationPath)
    func pop()
    func popToRoot()
}

class PathManager : ObservableObject, RCNavigationProtocol {
    @Published var paths: [RCNavigationPath] = []
    @Published var index: TabItem = .home
    static let manager: PathManager = .init()
    private init(){
        index = .home
    }
    func push(_ path: RCNavigationPath) {
        paths.append(path)
    }
    
    func pop() {
        paths.removeLast()
    }
    
    func popToRoot() {
        paths.removeAll()
    }
    
}
