import WebKit
import UIKit

public struct WBMessageHandler {
  let name: String
  let action: () -> Void
}

public struct WBUserScript {
  let javascript: String
  let injectionTime: WKUserScriptInjectionTime
  let forMainframeOnly: Bool
}

open class WebBridgeController: UIViewController {
  
  // MARK: - Properties
  public var backgroundColor: UIColor = .white {
    didSet {
      view.backgroundColor = backgroundColor
    }
  }
  
  public var handlers: [WBMessageHandler]
  public var scripts: [WBUserScript]
  
  private(set) var webview: WKWebView = WKWebView()
  
  // MARK: - init
  
  init(messageHandlers handlers: [WBMessageHandler], userScripts scripts: [WBUserScript]) {
    self.handlers = handlers
    self.scripts = scripts
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = backgroundColor
    
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

extension WebBridgeController: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let handler = handlers.first(where: { $0.name == message.name }) {
      handler.action()
    }
  }
}
