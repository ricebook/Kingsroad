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
    public private(set) var webView: WKWebView!

    public var jsScriptRunAfterWebViewInit: String?


    // MAKR: - init
    public init?(baseURL: NSURL, indexPath: String) {
        super.init(nibName: nil, bundle: nil)

        if baseURL.fileURL {
            // 如果是本地文件，则判断对应文件夹是否存在
            var isDirectory: ObjCBool = ObjCBool(false)
            let fileFolderPath = baseURL.path ?? ""
            let isExist = NSFileManager.defaultManager().fileExistsAtPath(fileFolderPath, isDirectory: &isDirectory)
            if !isExist || !isDirectory.boolValue {
                print("\(fileFolderPath) does not exist" )
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
    private var _baseURL: NSURL = NSURL(fileURLWithPath: "/")
    private var _indexPath: String = "index.html"

}

// MARK: - Extension: Life cycle
extension KingsroadViewController {
    // MARK: - Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        p_constructSubviews()

        let wholeURL = _baseURL.URLByAppendingPathComponent(_indexPath)
        if #available(iOS 9.0, *) {
            if _baseURL.fileURL {
                webView.loadFileURL(wholeURL, allowingReadAccessToURL: _baseURL)
                return
            }
        }
        webView.loadRequest(NSURLRequest(URL: wholeURL))
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Extension: Delegates
// MARK: KingsroadCommandDelegate
extension KingsroadViewController: KingsroadCommandDelegate {
    public func sendPluginResult(result: KingsroadPluginResult, callbackID: String) {

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
    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//        print(navigationAction)
        decisionHandler(.Allow)
    }

    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print(navigation)
    }
}

// MARK: WKUIDelegate
extension KingsroadViewController: WKUIDelegate {
    // HTML页面Alert出内容
    public func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let ac = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (_) -> Void in
            completionHandler()
        }))

        presentViewController(ac, animated: true, completion: nil)
    }

    // HTML页面弹出Confirm时调用此方法
    public func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        let ac = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler:
            { (_) -> Void in
                completionHandler(true)
        }))

        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:
            { (_) -> Void in
                completionHandler(false)
        }))

        presentViewController(ac, animated: true, completion: nil)
    }
}

// MARK: - Extension: Private methods
extension KingsroadViewController {
    private func p_constructSubviews() {
        let userContentController = WKUserContentController()

        if let jsString = jsScriptRunAfterWebViewInit where !jsString.isEmpty {
            let userScript = WKUserScript(source: jsString, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(userScript)
        }

        let cordovaMessageHandler = CordovaScriptMessageHandler()
        cordovaMessageHandler.commandDelgete = self
        userContentController.addScriptMessageHandler(cordovaMessageHandler, name: "cordova")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        webView = WKWebView(frame: CGRectZero, configuration: configuration)


        webView.navigationDelegate = self
        webView.UIDelegate = self
        webView.allowsBackForwardNavigationGestures = false

        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        let viewDic: [String: AnyObject] = [
            "webView": webView
        ]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDic)
        view.addConstraints(cons)

        cons = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDic)
        view.addConstraints(cons)

    }
}
