# FSPopoverView

[![Version Status](https://img.shields.io/cocoapods/v/FSPopoverView.svg)](https://cocoapods.org/pods/FSPopoverView)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![license MIT](https://img.shields.io/cocoapods/l/FSPopoverView.svg)](https://github.com/lifution/Popover/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/FSPopoverView.svg)](https://github.com/lifution/FSPopoverView/blob/master/README.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

FSPopoverView 是一个 popover 风格的弹窗，可自定义弹窗内容，类似 UITableView 的 data source，实现对应的协议即可自定义内容。FSPopoverView 同时提供了常用的列表功能：FSPopoverListView，该控件支持纵向和横向两个方向的布局。FSPopoverListView 中的 item 使用的是 model 驱动模式，和传统的 UITableViewCell 不一样，你只要定义 FSPopoverListItem 即可使用。

## Demo

#### 自定义内容
<p align="left"><img src="https://github.com/lifution/FSPopoverView/Screenshots/custom.PNG" width=20%/></p>
<p align="left"><img src="Screenshots/custom.PNG" width=20%/></p>

## Requirements

* iOS 11+
* Swift 5
* Xcode 14+

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

```ruby
pod 'FSPopoverView'
```

#### [Carthage](https://github.com/Carthage/Carthage)

````bash
github "lifution/FSPopoverView"
````

## License

FSPopoverView is available under the MIT license. [See the LICENSE](https://github.com/lifution/Popover/blob/master/LICENSE) file for more info.