//
//  KingsroadPluginResult.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

public enum KingsroadCommandStatus: Int {
    case noResult = 0
    case ok
    case classNotFoundException
    case illegalAccessException
    case malformedURLException
    case ioException
    case invalidAction
    case jsonException
    case error
}

public class KingsroadPluginResult: NSObject {
    private(set) var status: KingsroadCommandStatus
    var message: AnyObject?
    let keepCallback: Bool

    convenience public init(status: KingsroadCommandStatus) {
        self.init(status: status, message: nil, keepCallback: false)
    }

    convenience public init(status: KingsroadCommandStatus, message: AnyObject) {
        self.init(status: status, message: message, keepCallback: false)
    }

    public init(status: KingsroadCommandStatus, message: AnyObject?, keepCallback: Bool) {
        self.status = status
        self.message = message
        self.keepCallback = keepCallback

        super.init()
    }

    public class func errorWithMessage(_ msg: String) -> KingsroadPluginResult {
        return KingsroadPluginResult(status: .error, message: msg as NSString)
    }

    public class func dataFormatError() -> KingsroadPluginResult {
        return errorWithMessage("数据格式有误")
    }

    func constructResultJSWithCallbackID(_ callbackID: String) -> String {

        var resultInfoDic: [String: AnyObject] = [
            "status": "\(status.rawValue)" as NSString,
            "keepCallback": NSNumber(value: keepCallback)
        ]

        resultInfoDic["message"] = message

        // 默认是 Json 格式错误
        let resultParamStr: String
        if let jsonData = try? JSONSerialization.data(withJSONObject: resultInfoDic, options: JSONSerialization.WritingOptions()),
            let paramStr = String(data: jsonData, encoding: String.Encoding.utf8)
        {
            resultParamStr = paramStr
        } else {
            // 如果 Json 序列化错误，则将状态置为这个
            status = .jsonException
            resultParamStr = "{\"status\":\"7\",\"message\":\"JsonException\",\"keepCallback\":false}"
        }

        let resultJS: String

        switch status {
        case .ok:
            resultJS = "cordova.callbackSuccess('\(callbackID)', \(resultParamStr));"
        default:
            resultJS = "cordova.callbackError('\(callbackID)', \(resultParamStr));"
        }

        return resultJS
    }

}
