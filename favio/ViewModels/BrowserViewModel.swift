import SwiftUI
import WebKit
import Combine

class BrowserViewModel: NSObject, ObservableObject {
    @Published var urlString: String = "https://www.apple.com"
    @Published var currentURL: URL = URL(string: "https://www.apple.com")!
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var pageTitle: String = "Browser"
    
    let webView: WKWebView
    
    override init() {
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        super.init()
        
        self.webView.navigationDelegate = self
        setupObservers()
    }
    
    func loadURL() {
        var stringToLoad = urlString
        if !stringToLoad.hasPrefix("http://") && !stringToLoad.hasPrefix("https://") {
            if stringToLoad.contains(".") && !stringToLoad.contains(" ") {
                stringToLoad = "https://" + stringToLoad
            } else {
                if let encoded = stringToLoad.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    stringToLoad = "https://www.google.com/search?q=\(encoded)"
                }
            }
        }
        
        if let url = URL(string: stringToLoad) {
            webView.load(URLRequest(url: url))
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupObservers() {
        webView.publisher(for: \.canGoBack)
            .receive(on: RunLoop.main)
            .assign(to: \.canGoBack, on: self)
            .store(in: &cancellables)
            
        webView.publisher(for: \.canGoForward)
            .receive(on: RunLoop.main)
            .assign(to: \.canGoForward, on: self)
            .store(in: &cancellables)
            
        webView.publisher(for: \.title)
            .receive(on: RunLoop.main)
            .sink { [weak self] title in
                self?.pageTitle = title ?? "Browser"
            }
            .store(in: &cancellables)
            
        webView.publisher(for: \.url)
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                guard let self = self, let url = url else { return }
                self.currentURL = url
                self.urlString = url.absoluteString
            }
            .store(in: &cancellables)
    }
}

extension BrowserViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load: \(error.localizedDescription)")
    }
}
