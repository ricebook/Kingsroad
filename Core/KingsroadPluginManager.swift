//
//  KingsroadPluginManager.swift
//  Daenerys
//
//  Created by Carl Chen on 3/1/16.
//  Copyright © 2016 Carl Chen. All rights reserved.
//

import UIKit

class KingsroadPluginManager {
    static let sharedManager = KingsroadPluginManager()

    private init() {

    }

    /**
     Register plugin.

     - parameter name:       Name of plugin that is used in js
     - parameter pluginType: The Class of plugin
     */
    func registerPluginTypeWithName(name: String, pluginType: KingsroadPlugin.Type) {
        _pluginTypeMap[name] = pluginType
    }


    func registerPlugins(plugins: [String: KingsroadPlugin.Type]) {
        for (key, value) in plugins {
            _pluginTypeMap[key] = value
        }
    }

    subscript(pluginName: String) -> KingsroadPlugin.Type? {
        return _pluginTypeMap[pluginName]
    }


    // MARK: - Private properties
    private var _pluginTypeMap: [String: KingsroadPlugin.Type] = [:]
}
