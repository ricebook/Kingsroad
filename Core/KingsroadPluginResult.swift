//
//  KingsroadPluginResult.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

enum KingsroadCommandStatus: Int {
    case NoResult = 0
    case OK
    case ClassNotFoundException
    case IllegalAccessException
    case MalformedURLException
    case IOException
    case InvalidAction
    case JsonException
    case Error
}

class KingsroadPluginResult: NSObject {
    private(set) var status: KingsroadCommandStatus
    var message: AnyObject?
    let keepCallback: Bool

    convenience init(status: KingsroadCommandStatus) {
        self.init(status: status, message: nil, keepCallback: false)
    }

    convenience init(status: KingsroadCommandStatus, message: AnyObject) {
        self.init(status: status, message: message, keepCallback: false)
    }

    init(status: KingsroadCommandStatus, message: AnyObject?, keepCallback: Bool) {
        self.status = status
        self.message = message
        self.keepCallback = keepCallback

        super.init()
    }

    class func errorWithMessage(msg: String) -> KingsroadPluginResult {
        return KingsroadPluginResult(status: .Error, message: msg)
    }

    class func dataFormatError() -> KingsroadPluginResult {
        return errorWithMessage("数据格式有误")
    }

    func constructResultJSWithCallbackID(callbackID: String) -> String {

        var resultInfoDic: [String: AnyObject] = [
            "status": "\(status.rawValue)",
            "keepCallback": keepCallback
        ]

        resultInfoDic["message"] = message

        // 默认是 Json 格式错误
        let resultParamStr: String
        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(resultInfoDic, options: NSJSONWritingOptions()),
            paramStr = String(data: jsonData, encoding: NSUTF8StringEncoding)
        {
            resultParamStr = paramStr
        } else {
            // 如果 Json 序列化错误，则将状态置为这个
            status = .JsonException
            resultParamStr = "{\"status\":\"7\",\"message\":\"JsonException\",\"keepCallback\":false}"
        }

        let resultJS: String

        switch status {
        case .OK:
            resultJS = "cordova.callbackSuccess('\(callbackID)', \(resultParamStr));"
        default:
            resultJS = "cordova.callbackError('\(callbackID)', \(resultParamStr));"
        }

        return resultJS
    }

}
