//
//  CordovaScriptMessageHandler.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit
import WebKit



public class CordovaScriptMessageHandler: NSObject, WKScriptMessageHandler {
    public weak var commandDelgete: KingsroadCommandDelegate? = nil

    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {

        guard message.name == "cordova" else {
            return
        }

        guard let msgBody = message.body as? [AnyObject]
        where msgBody.count >= 4
        else {
            return
        }

        guard let callbackID = msgBody[0] as? String,
        pluginName = msgBody[1] as? String,
        pluginMethodName = msgBody[2] as? String,
        methodArguments = msgBody[3] as? [AnyObject]
        else {
            return
        }

        let command = KingsroadCommand(callbackID: callbackID, pluginName: pluginName, pluginMethodName: pluginMethodName, methodArguments: methodArguments)

        guard let pluginType = KingsroadPluginManager.sharedManager[pluginName] else {
            print("Plugin \(pluginName) not found.")
            return
        }

        let plugin: KingsroadPlugin
        if let cachedPlugin = _pluginMap[pluginName] {
            plugin = cachedPlugin
        } else {
            plugin = pluginType.init()
            plugin.commandDelgete = commandDelgete
            _pluginMap[pluginName] = plugin
        }

        let methodSelector = Selector(pluginMethodName + ":")
        if plugin.respondsToSelector(methodSelector) {
            plugin.performSelector(methodSelector, withObject: command)
        }

    }

    private var _pluginMap: [String: KingsroadPlugin] = [:]
}
