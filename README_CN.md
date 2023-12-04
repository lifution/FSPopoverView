# FSPopoverView

[![Version Status](https://img.shields.io/cocoapods/v/FSPopoverView.svg)](https://cocoapods.org/pods/FSPopoverView)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![license MIT](https://img.shields.io/cocoapods/l/FSPopoverView.svg)](https://github.com/lifution/Popover/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/FSPopoverView.svg)](https://github.com/lifution/FSPopoverView/blob/master/README.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

FSPopoverView 是一个 popover 风格的弹窗，可自定义弹窗内容，类似 UITableView 的 data source，实现对应的协议即可自定义内容。FSPopoverView 同时提供了常用的列表功能：FSPopoverListView，该控件支持纵向和横向两个方向的布局。FSPopoverListView 中的 item 使用的是 model 驱动模式，和传统的 UITableViewCell 不一样，你只要定义 FSPopoverListItem 即可使用。

## 示例

|<div style="width: 25%">**自定义内容**</div>|<div style="width: 25%">**列表（Light）**</div>|<div style="width: 25%">**列表（Dark）**</div>|<div style="width: 25%">**列表（自定义 item）**</div>|
|:--:|:--:|:--:|:--:|
|<div style="width: 25%"><img src="Screenshots/custom.PNG"></div>|<div style="width: 25%"><img src="Screenshots/list_light.PNG"></div>|<div style="width: 25%"><img src="Screenshots/list_dark.PNG"></div>|<div style="width: 25%"><img src="Screenshots/custom_item.PNG"></div>|

|**列表（横向布局）**|
|:--:|
|<img src="Screenshots/menu.PNG">|

## 功能

- [x] Supports customization
- [x] Supports arrow direction
- [x] Supports hidden Arrow
- [x] Supports custom border
- [x] Supports custom shadow
- [x] Supports custom transition animation
- [x] Supports custom list item
- [x] Supports dark mode
- [x] Supports global appearance
- [ ] Supports arrow direction priority
- [ ] Supports list appends item

## 要求

* iOS 11+
* Swift 5
* Xcode 14+

## 安装

#### [CocoaPods](http://cocoapods.org) (推荐)

```ruby
pod 'FSPopoverView'
```

#### [Carthage](https://github.com/Carthage/Carthage)

````bash
github "lifution/FSPopoverView"
````

#### 手动复制

下载仓库后把目录下的 `FSPopoverView` 文件夹拖入你的项目中，并且勾选 `Copy items if needed` 和 `Create groups`。

## License

FSPopoverView 基于 MIT 许可开源，更多开源许可信息可 [查看该文件](https://github.com/lifution/Popover/blob/master/LICENSE)。