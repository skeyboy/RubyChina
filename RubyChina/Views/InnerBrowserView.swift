//
//  BrowserView.swift
//  RubyChina
//
//  Created by lee on 2024/12/2.
//

import SwiftUI
import SwiftUIWebView
import Alamofire
@preconcurrency
import WebKit

typealias StringBlock = (String) -> Void
typealias BoolBlock = (Bool) -> Void
typealias WebLoadingStatusBlock = (LoadingStaus) -> Void
typealias DoubleBlock = (Double) -> Void

enum LoadingStaus: String {
    case wait = "wait"
    case finish = "finish"
    case fail = "faile"
}

class BrowserManager {
    let webView: WKWebView
    
    init(){
        let pres = WKWebpagePreferences()
        pres.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pres
        self.webView = WKWebView(frame: .zero, configuration:  config)
    }
    
    func goBack(){
        if(webView.canGoBack){
            webView.goBack()
        }
    }
}


struct InnerBrowserView: UIViewRepresentable {
    
    private let manager: BrowserManager = .init()
    
    private var listenTitle: StringBlock?
    private var listenCanGoBack: BoolBlock?
    private var listenLoadingStatus: WebLoadingStatusBlock?
    private var listenEstimatedProgress: DoubleBlock?
    
    init(
         listenTitle: StringBlock? = nil,
         listenCanGoBack: BoolBlock? = nil,
         listenLoadingStatus: WebLoadingStatusBlock? = nil, listenEstimatedProgress: DoubleBlock? = nil){
        self.listenTitle = listenTitle
        self.listenCanGoBack = listenCanGoBack
        self.listenLoadingStatus = listenLoadingStatus
        self.listenEstimatedProgress = listenEstimatedProgress
    }
    
    func makeUIView(context: Context) -> WKWebView {
        manager.webView.navigationDelegate = context.coordinator
        return manager.webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        let parent: InnerBrowserView
        
        init(_ parent: InnerBrowserView) {
            self.parent = parent
            super.init()
            
            if(self.parent.listenTitle != nil){
                self.parent.manager.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
            }
            if(self.parent.listenCanGoBack != nil){
                self.parent.manager.webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
            }
            if(self.parent.listenEstimatedProgress != nil) {
                self.parent.manager.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            }
        }
        
        deinit{
            if(self.parent.listenTitle != nil){
                self.parent.manager.webView.removeObserver(self, forKeyPath: "title")
            }
            if(self.parent.listenCanGoBack != nil){
                self.parent.manager.webView.removeObserver(self, forKeyPath: "canGoBack")
            }
            if(self.parent.listenEstimatedProgress != nil) {
                self.parent.manager.webView.removeObserver(self, forKeyPath: "estimatedProgress")
            }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if let callback = self.parent.listenLoadingStatus{
                callback(.wait)
            }
        }
    
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let callback = self.parent.listenLoadingStatus{
                callback(.finish)
            }
        }
    
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            if let callback = self.parent.listenLoadingStatus{
                callback(.fail)
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // TODO
            if let url = navigationAction.request.url?.absoluteString {
                //url拦截
                if(url.contains("你要拦截的urL")){
                    //处理拦截逻辑
                }
            }
            decisionHandler(.allow)
        }
        
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if(keyPath == "title"){
                if let callback = self.parent.listenTitle {
                    callback(self.parent.manager.webView.title ?? "")
                }
            }
            if(keyPath == "canGoBack"){
                if let callback = self.parent.listenCanGoBack {
                    callback(self.parent.manager.webView.canGoBack)
                }
            }
            if(keyPath == "estimatedProgress"){
                if let callback = self.parent.listenEstimatedProgress {
                    callback(self.parent.manager.webView.estimatedProgress)
                }
            }
        }
    }
    
    func loadUrl(_ urlString: String) -> Self{
        let url = URL.init(string: urlString)
        if let _url = url {
            return loadUrl(_url)
        }

        return self
    }
    
    @discardableResult
    func loadUrl(_ url: URL) -> Self {
        let request = URLRequest.init(url: url)
        self.manager.webView.load(request)
        return self
    }
}

struct BrowserView : View {
    
    @Binding  var title: String?
    @State private var canGoBack: Bool?
    @Binding var loadingStatus: LoadingStaus
    @State private var estimatedProgress: Double?
    @State var url:URL
   
    var body: some View {
        InnerBrowserView( listenTitle: { title in
            self.title = title
            print("title: \(title)")
        }, listenCanGoBack: { canGoBack in
            self.canGoBack = canGoBack
            print("canGoBack: \(canGoBack)")
        }, listenLoadingStatus: { loadingStaus in
            self.loadingStatus = loadingStaus
            print("loadingStaus: \(loadingStaus)")
        }, listenEstimatedProgress: { estimatedProgress in
            self.estimatedProgress = estimatedProgress
            print("estimatedProgress: \(estimatedProgress)")
        })
        .loadUrl(url)
    }
}

#Preview {
    BrowserView(title: .constant(""),
                loadingStatus: .constant(.wait),
                url: URL(string: "https://www.baidu.com")!)
}
