import WebKit
import UIKit

struct WBMessageHandler {
  let name: String
  let action: () -> Void
}

struct WBUserScript {
  let javascript: String
  let injectionTime: WKUserScriptInjectionTime
  let forMainframeOnly: Bool
}

final class WebBridgeController: UIViewController, WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    // TODO: -
  }
  
  public var backgroundColor: UIColor?
  public var handlers: [WBMessageHandler]
  public var scripts: [WBUserScript]
  
  private(set) var webview: WKWebView = WKWebView()
  
  init(messageHandlers handlers: [WBMessageHandler], userScripts scripts: [WBUserScript]) {
    self.handlers = handlers
    self.scripts = scripts
    
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = backgroundColor ?? .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let configuration = WKWebViewConfiguration()
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    preferences.javaScriptCanOpenWindowsAutomatically = true
    
    configuration.preferences = preferences
    
    for handler in handlers {
      configuration.userContentController.add(self, name: handler.name)
    }
    
    for script in scripts {
      let wkScript = WKUserScript(source: script.javascript, injectionTime: script.injectionTime, forMainFrameOnly: script.forMainframeOnly)
      configuration.userContentController.addUserScript(wkScript)
    }
    
    webview = WKWebView(frame: .zero, configuration: configuration)
  }
  
}
