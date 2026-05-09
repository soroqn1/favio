import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var viewModel = BrowserViewModel()

    var body: some View {
        WebView(url: viewModel.currentURL, webView: viewModel.webView)
            .navigationTitle(viewModel.pageTitle)
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button(action: { viewModel.webView.goBack() }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!viewModel.canGoBack)

                    Button(action: { viewModel.webView.goForward() }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!viewModel.canGoForward)

                    Button(action: { viewModel.webView.reload() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }

                ToolbarItem(placement: .principal) {
                    TextField("Search or enter address", text: $viewModel.urlString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity)
                        .onSubmit {
                            viewModel.loadURL()
                        }
                }
            }
    }
}
