import UIKit
import WebKit
import AuthenticationServices

final class WebViewController: UIViewController {

    /// Where the Old Tunes web app lives.
    static let home = URL(string: "https://harriparna-creator.github.io/oldtunes/")!
    /// Spotify sends the sign-in result to the web page you already registered (the https address above);
    /// that page passes it back to the app through this address, which the sign-in sheet catches.
    static let callbackScheme = "oldtunes"

    private var webView: WKWebView!
    private var authSession: ASWebAuthenticationSession?
    private let background = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func loadView() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()                 // keeps you signed in and keeps your Record Shelf
        config.allowsInlineMediaPlayback = true
        config.applicationNameForUserAgent = "OldTunesApp/1.0 Mobile/15E148 Safari/604.1"

        let content = WKUserContentController()
        let flag = "window.OT_NATIVE = { redirect: '\(Self.home.absoluteString)', platform: 'ios', version: 1 };"
        content.addUserScript(WKUserScript(source: flag, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        content.add(WeakScriptHandler(self), name: "otAuth")
        config.userContentController = content

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsLinkPreview = false
        webView.isOpaque = false
        webView.backgroundColor = background
        webView.scrollView.backgroundColor = background
        webView.scrollView.contentInsetAdjustmentBehavior = .never   // the page handles the notch and home bar itself
        webView.scrollView.bounces = false
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: Self.home))
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    /// Coming back from the Spotify app: let the page pick up where it left off (e.g. start the song you chose).
    @objc private func appBecameActive() {
        webView.evaluateJavaScript("window.otNativeResume && window.otNativeResume()", completionHandler: nil)
    }

    private func showOfflinePage() {
        let html = """
        <html><head><meta name='viewport' content='width=device-width,initial-scale=1'>
        <style>body{background:#111;color:#ddd;font:16px -apple-system;display:flex;flex-direction:column;align-items:center;justify-content:center;height:100vh;margin:0;text-align:center;padding:0 30px}
        a{margin-top:18px;padding:10px 22px;border-radius:10px;background:#3a73d8;color:#fff;text-decoration:none;font-weight:600}</style></head>
        <body><div><b>Old Tunes can't connect.</b><br><br>Check your internet connection.</div><a href='\(Self.home.absoluteString)'>Try again</a></body></html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}

// MARK: - Spotify sign-in with the system sign-in sheet

extension WebViewController: WKScriptMessageHandler, ASWebAuthenticationPresentationContextProviding {

    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "otAuth",
              let string = message.body as? String,
              let url = URL(string: string),
              url.host == "accounts.spotify.com" else { return }

        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: Self.callbackScheme) { [weak self] callback, _ in
            DispatchQueue.main.async {
                guard let self, let callback,
                      let query = URLComponents(url: callback, resolvingAgainstBaseURL: false)?.percentEncodedQuery,
                      let data = try? JSONEncoder().encode("?" + query),
                      let argument = String(data: data, encoding: .utf8) else { return }   // cancelled: nothing to do
                self.webView.evaluateJavaScript("window.otAuthCallback && window.otAuthCallback(\(argument))", completionHandler: nil)
            }
        }
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = false
        authSession = session
        session.start()
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window ?? ASPresentationAnchor()
    }
}

// MARK: - Links: Spotify app links and outside websites leave the app

extension WebViewController: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = action.request.url else { return decisionHandler(.allow) }
        let scheme = (url.scheme ?? "").lowercased()

        // spotify: and other app links (e.g. "Wake Spotify") open the other app
        if !["http", "https", "about", "data", "blob"].contains(scheme) {
            UIApplication.shared.open(url)
            return decisionHandler(.cancel)
        }
        // links to other websites open in Safari
        if action.navigationType == .linkActivated, url.host != Self.home.host {
            UIApplication.shared.open(url)
            return decisionHandler(.cancel)
        }
        decisionHandler(.allow)
    }

    // target="_blank" links
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = action.request.url { UIApplication.shared.open(url) }
        return nil
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let e = error as NSError
        let offline: Set<Int> = [NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut, NSURLErrorCannotFindHost,
                                 NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorDNSLookupFailed]
        if e.domain == NSURLErrorDomain, offline.contains(e.code) { showOfflinePage() }
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}

/// Avoids a retain cycle between the web view and its controller.
private final class WeakScriptHandler: NSObject, WKScriptMessageHandler {
    weak var target: WKScriptMessageHandler?
    init(_ target: WKScriptMessageHandler) { self.target = target }
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        target?.userContentController(controller, didReceive: message)
    }
}
