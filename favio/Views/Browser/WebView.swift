import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        webView.allowsBackForwardNavigationGestures = true
        if webView.url == nil {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
    }
}
