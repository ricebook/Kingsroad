//
//  KingsroadCommand.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

@objc public protocol KingsroadCommandDelegate {
    func sendPluginResult(result: KingsroadPluginResult, callbackID: String)
}

public class KingsroadCommand: NSObject {

    public let callbackID: String
    public let pluginName: String
    public let pluginMethodName: String
    public let methodArguments: [AnyObject]

    public init(callbackID: String,
        pluginName: String,
        pluginMethodName: String,
        methodArguments: [AnyObject])
    {
        self.callbackID = callbackID
        self.pluginName = pluginName
        self.pluginMethodName = pluginMethodName
        self.methodArguments = methodArguments
    }

    
}
