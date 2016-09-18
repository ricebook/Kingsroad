//
//  KingsroadPluginManager.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

public class KingsroadPluginManager {
    public static let sharedManager = KingsroadPluginManager()

    private init() {

    }

    /**
     Register plugin.

     - parameter name:       Name of plugin that is used in js
     - parameter pluginType: The Class of plugin
     */
    public func registerPluginTypeWithName(_ name: String, pluginType: KingsroadPlugin.Type) {
        _pluginTypeMap[name] = pluginType
    }


    public func registerPlugins(_ plugins: [String: KingsroadPlugin.Type]) {
        for (key, value) in plugins {
            _pluginTypeMap[key] = value
        }
    }

    public subscript(pluginName: String) -> KingsroadPlugin.Type? {
        return _pluginTypeMap[pluginName]
    }


    // MARK: - Private properties
    private var _pluginTypeMap: [String: KingsroadPlugin.Type] = [:]
}
