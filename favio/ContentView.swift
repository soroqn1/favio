import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}

struct ContentView: View {
    @State private var urlString = "https://google.com"

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Search or enter URL", text: $urlString)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                    }
            }
            .padding(8)
            .background(.ultraThinMaterial)

            WebView(url: URL(string: urlString) ?? URL(string: "https://google.com")!)
        }
    }
}
