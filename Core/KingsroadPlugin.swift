//
//  KingsroadPlugin.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

public class KingsroadPlugin: NSObject {

    weak public var commandDelgete: KingsroadCommandDelegate? = nil

    override required public init() {
        super.init()
    }

    public func judgeCommandMethodArgumentCount(_ command: KingsroadCommand, rightCount count: UInt) -> KingsroadPluginResult? {
        let result: KingsroadPluginResult?
        if command.methodArguments.count != Int(count) {
            result = KingsroadPluginResult.errorWithMessage("argument count is wrong.")
        }else {
            result = nil
        }

        return result
    }
}
