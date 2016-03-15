Kingsroad
======

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Kingsroad is an iOS hybrid framework written in Swift that using WKWebView and is compatible to Cordova JS interface.

## Requirements

- iOS 8.0+
- Xcode 7.2+

## TODO List

- [ ] Unit Test

## Attention

WKWebView has some known problems, If you use Kingsroad, you should handle these problems yourself.

### Loading local file under iOS8

There is a discuss about this problem on [Stackoverflow](http://stackoverflow.com/questions/24882834/wkwebview-not-loading-local-files-under-ios-8)

In general, if your app support iOS8, there is two way to solve this problem.

* Move your local file to the Temp directory of your app.
* Start a local web server and load your hybrid resource through http.



### CROS

Here is a [document](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Access_control_CORS) about CROS.

If your local hybrid page send a http request by XMLHttpRequest, like request an API of server. Server should be configured to support CORS, or your request will fail.


## Installation

If you're using [Carthage](https://github.com/Carthage/Carthage) you can add a dependency on ObjectMapper by adding it to your `Cartfile`:

```
github "ricebook/Kingsroad" ~> 0.1
```

You can also use git submodule to install Kingsroad.

## License

Kingsroad is released under the MIT license. See LICENSE for details.