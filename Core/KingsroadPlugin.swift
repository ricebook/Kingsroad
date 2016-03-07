//
//  KingsroadPlugin.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

class KingsroadPlugin: NSObject {

    weak var commandDelgete: KingsroadCommandDelegate? = nil

    override required init() {
        super.init()
    }

    func judgeCommandMethodArgumentCount(command: KingsroadCommand, rightCount count: UInt) -> KingsroadPluginResult? {
        let result: KingsroadPluginResult?
        if command.methodArguments.count != Int(count) {
            result = KingsroadPluginResult.errorWithMessage("argument count is wrong.")
        }else {
            result = nil
        }

        return result
    }
}
