Kingsroad
======

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Kingsroad is an iOS hybrid framework written in Swift that using WKWebView and is compatible to Cordova JS interface.

## Features

- WKWebView supportable
- Cordova JS interface compatible
- Write plugin in Swift


## Requirements

- iOS 8.0+
- Xcode 7.2+

## TODO List

- [ ] Localization
- [ ] Unit Test

## Attention

WKWebView has some known problems, If you use Kingsroad, you should handle these problems yourself.

#### 1. Loading local file under iOS8

There is a discuss about this problem on [Stackoverflow](http://stackoverflow.com/questions/24882834/wkwebview-not-loading-local-files-under-ios-8)

In general, if your app support iOS8, there is two way to solve this problem.

* Move your local file to the Temp directory of your app.
* Start a local web server(like [GCDWebServer](https://github.com/Hearst-DD/ObjectMapper)) and load your hybrid resource through http.

#### 2. CORS

Here is a [document](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Access_control_CORS) about CORS.

If your local hybrid page send a http request by XMLHttpRequest, like request an API of server. Server should be configured to support CORS, or your request will fail.

## Usage

Usage of Kingsroad is very similar to Cordova.

Register your plugins when app launch. 

``` Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

	KingsroadPluginManager.sharedManager.registerPlugins([
            "XXXX": Plugin1ClassName.self,
            "YYYY": Plugin2ClassName.self,
        ])

	.....
}

```

Write a custom plugin is very similar to Cordova. 

Plugin should inherit `KingsroadPlugin`, and remember to register it.

Format of plugin method:

``` Swift
func methodName(command: KingsroadCommand) {

}

```


## Installation

If you're using [Carthage](https://github.com/Carthage/Carthage) you can add a dependency on Kingsroad by adding it to your `Cartfile`:

```
github "ricebook/Kingsroad" ~> 0.1
```

You can also use git submodule to install Kingsroad.

## License

Kingsroad is released under the MIT license. See LICENSE for details.