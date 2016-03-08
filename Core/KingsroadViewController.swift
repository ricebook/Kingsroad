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
    private(set) var webView: WKWebView!

    public var jsScriptRunAfterWebViewInit: String?


    // MAKR: - init
    public init?(workFolderFileURL: NSURL, indexRelativePath: String) {
        super.init(nibName: nil, bundle: nil)

        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = NSFileManager.defaultManager().fileExistsAtPath(workFolderFileURL.path ?? "", isDirectory: &isDirectory)

        if !isExist || !isDirectory.boolValue {
            print("\(workFolderFileURL.path) does not exist" )
            return nil
        }

        _workFolderURL = workFolderFileURL
        _indexPath = indexRelativePath

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - Private properties
    private var _loadFileURL: NSURL?

    private var _workFolderURL: NSURL?
    private var _indexPath: String = "index.html"

}

// MARK: - Extension: Life cycle
extension KingsroadViewController {
    // MARK: - Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        p_constructSubviews()

        if let workFolder = _workFolderURL {
            if #available(iOS 9.0, *) {
                webView.loadFileURL(workFolder.URLByAppendingPathComponent(_indexPath), allowingReadAccessToURL: workFolder)
            } else {
                let url = workFolder.URLByAppendingPathComponent(_indexPath)
                webView.loadRequest(NSURLRequest(URL: url))
            }
        }
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
                print("Callback JS run successfully. Result : \(obj)")
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
