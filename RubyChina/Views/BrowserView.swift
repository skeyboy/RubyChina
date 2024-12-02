//
//  BrowserView.swift
//  RubyChina
//
//  Created by lee on 2024/12/2.
//

import SwiftUI
import SwiftUIWebView
import Alamofire
import WebKit

class ViewModel: NSObject  {
    var title: String?
    lazy  var webView: WKWebView = {
        let wkWebView = WKWebView()
        wkWebView.customUserAgent = "User-Agent:Mozilla/5.0 (Linux; Android 4.1.2; Nexus 7 Build/JZ054K) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Safari/535.19"
        return wkWebView
    }()
    var browser: Browser
    
    init(_ browser: Browser){
        self.browser = browser
    }
}

struct Browser: UIViewRepresentable {
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.webView.load(URLRequest(url: url))
        
    }
    
    func makeCoordinator() -> ViewModel {
        ViewModel(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = context.coordinator.webView
        webView.load(URLRequest(url: url))
        return webView
    }
    typealias UIViewType = WKWebView
    @State var url: URL
    
}
struct BrowserView: View {
    @State private var action = WebViewAction.idle
    @State private var state = WebViewState.empty
    @State private var address = "https://www.google.com"
    
    @State var url: URL
    
    @State private var loadingProgress: CGFloat = 0
    var body: some View {
        VStack(alignment: .leading) {
            Browser(url: url)
                .edgesIgnoringSafeArea([.bottom])
                .onAppear {
                    
                    action = WebViewAction.load(URLRequest(url: url))
                    
                }.defaultView()
        }.navigationTitle(Text(url.absoluteString))
        
    }
}

#Preview {
    BrowserView(url: URL(string: "https://www.baidu.com")!)
}
