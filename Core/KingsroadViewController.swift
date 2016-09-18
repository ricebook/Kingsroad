//
//  KingsroadViewController.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit
import WebKit

public class KingsroadViewController: UIViewController {
    public fileprivate(set) var webView: WKWebView!

    public var jsScriptRunAfterWebViewInit: String?


    // MAKR: - init
    public init?(baseURL: URL, indexPath: String) {
        super.init(nibName: nil, bundle: nil)

        if baseURL.isFileURL {
            // 如果是本地文件，则判断对应文件夹是否存在
            var isDirectory: ObjCBool = ObjCBool(false)
            let isExist = FileManager.default
                .fileExists(atPath: baseURL.path, isDirectory: &isDirectory)
            if !isExist || !isDirectory.boolValue {
                print("\(baseURL.path) does not exist" )
                return nil
            }
        }

        _baseURL = baseURL
        _indexPath = indexPath

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - Private properties
    fileprivate var _baseURL: URL = URL(fileURLWithPath: "/")
    fileprivate var _indexPath: String = "index.html"

}

// MARK: - Extension: Life cycle
extension KingsroadViewController {
    // MARK: - Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        p_constructSubviews()
        let wholeURLString = _baseURL.absoluteString + "/" + _indexPath
        guard let wholeURL = URL(string: wholeURLString) else { return }

        if #available(iOS 9.0, *) {
            if _baseURL.isFileURL {
                webView.loadFileURL(wholeURL, allowingReadAccessTo: _baseURL)
                return
            }
        }
        webView.load(URLRequest(url: wholeURL))
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Extension: Delegates
// MARK: KingsroadCommandDelegate
extension KingsroadViewController: KingsroadCommandDelegate {
    public func sendPluginResult(_ result: KingsroadPluginResult, callbackID: String) {

        let resultJS = result.constructResultJSWithCallbackID(callbackID)
        webView.evaluateJavaScript(resultJS) { (obj, error) -> Void in
            if error == nil {
//                print("Callback JS run successfully. Result : \(obj)")
            } else {
                print("Callback JS run error. \(error)")
            }
        }

    }
}

// MARK: WKNavigationDelegate
extension KingsroadViewController: WKNavigationDelegate {
    @nonobjc public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//        print(navigationAction)
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(navigation)
    }
}

// MARK: WKUIDelegate
extension KingsroadViewController: WKUIDelegate {
    // HTML页面Alert出内容
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) -> Void in
            completionHandler()
        }))

        present(ac, animated: true, completion: nil)
    }

    // HTML页面弹出Confirm时调用此方法
    @nonobjc public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let ac = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler:
            { (_) -> Void in
                completionHandler(true)
        }))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
            { (_) -> Void in
                completionHandler(false)
        }))

        present(ac, animated: true, completion: nil)
    }
}

// MARK: - Extension: Private methods
fileprivate extension KingsroadViewController {
    func p_constructSubviews() {
        let userContentController = WKUserContentController()

        if let jsString = jsScriptRunAfterWebViewInit, !jsString.isEmpty {
            let userScript = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(userScript)
        }

        let cordovaMessageHandler = CordovaScriptMessageHandler()
        cordovaMessageHandler.commandDelgete = self
        userContentController.add(cordovaMessageHandler, name: "cordova")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)


        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false

        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        let viewDic: [String: AnyObject] = [
            "webView": webView
        ]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDic)
        view.addConstraints(cons)

        cons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDic)
        view.addConstraints(cons)

    }
}
