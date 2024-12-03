//
//  WebView.swift
//  RubyChina
//
//  Created by lee on 2024/12/3.
//

import SwiftUI

struct WebView: View {
    var urlString: String?
    var url: URL?
    @State private var status: LoadingStaus = .wait
    @State private var title: String? = nil
    private var innerURL: URL?
    private init(urlString: String? = nil, url: URL? = nil) {
        self.urlString = urlString
        self.url = url
        if url != nil  && urlString != nil {
            assert(false, "两者不能同时存在")
        }
        if let urlString = urlString, let url = URL(string: urlString) {
            self.innerURL = url
        }
        if let url = url {
            self.innerURL = url
        }
    }
    
    init(_ url: URL?) {
        self.url = url
        self.urlString = nil
        if let url = url {
            self.innerURL = url
        }
    }
    
    init(_ url: String) {
        self.init(urlString: url, url: nil)
    }
    
    var body: some View {
        VStack {
            if status == .wait {
                ProgressView()
            }
            if status == .fail {
                VStack {
                    Text("网络加载异常")
                }
            }
            if let innerURL = innerURL {
                BrowserView(title: $title,
                            loadingStatus: $status,
                            url: innerURL)
            }
         
        }
        .navigationTitle(Text( title ?? (innerURL?.absoluteString ?? "")))
    }
}

#Preview {
    WebView("https://www.baidu.com")
}
