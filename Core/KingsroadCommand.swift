//
//  KingsroadCommand.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

@objc protocol KingsroadCommandDelegate {
    func sendPluginResult(result: KingsroadPluginResult, callbackID: String)
}

class KingsroadCommand: NSObject {

    let callbackID: String
    let pluginName: String
    let pluginMethodName: String
    let methodArguments: [AnyObject]

    init(callbackID: String,
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
