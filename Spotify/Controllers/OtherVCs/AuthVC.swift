//
//  AuthVC.swift
//  Spotify
//
//  Created by Khalmatov on 10.09.2023.
//

import UIKit
import WebKit


class AuthVC: UIViewController, WKNavigationDelegate {
    
    public var completionHandler: ((Bool) -> Void)?
    
    private let webView: WKWebView = {
        let pref = WKWebpagePreferences()
        let config = WKWebViewConfiguration()
        pref.allowsContentJavaScript = true
        config.defaultWebpagePreferences = pref
        let webView: WKWebView
        webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
    }
    
    
    
    fileprivate func setUpUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.navigationDelegate = self
        guard let url = AuthManager.shared.signInUrl else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        //        Exchange code for acsess token
        let component = URLComponents(string: url.absoluteString)
        
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        
        webView.isHidden = true
        
          DispatchQueue.main.async {
            AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
             }
        }
    }
    
    
}
