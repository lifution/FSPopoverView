# FSPopoverView

[![Platform](https://img.shields.io/badge/Platform-iOS-yellowgreen)](https://img.shields.io/badge/Platform-iOS-yellowgreen)
[![Swift 5.x](https://img.shields.io/badge/Swift-5.x-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![ObjC incompatible](https://img.shields.io/badge/ObjC-incompatible-red)](https://img.shields.io/badge/ObjC-incompatible-red)
[![Version Status](https://img.shields.io/cocoapods/v/FSPopoverView.svg)](https://cocoapods.org/pods/FSPopoverView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange)
[![license MIT](https://img.shields.io/cocoapods/l/FSPopoverView.svg)](https://github.com/lifution/FSPopoverView/blob/master/LICENSE)

### [中文介绍](https://github.com/lifution/FSPopoverView/blob/master/README_CN.md)

A library to present popovers.

## Demo

|<div style="width: 25%">**Custom content**</div>|<div style="width: 25%">**List (Light)**</div>|<div style="width: 25%">**List (Dark)**</div>|<div style="width: 25%">**List (Custom item)**</div>|
|:--:|:--:|:--:|:--:|
|<div style="width: 25%"><img src="Screenshots/custom.PNG"></div>|<div style="width: 25%"><img src="Screenshots/list_light.PNG"></div>|<div style="width: 25%"><img src="Screenshots/list_dark.PNG"></div>|<div style="width: 25%"><img src="Screenshots/custom_item.PNG"></div>|
|**List (Horizontal layout)**|
|<img src="Screenshots/menu.PNG">|

## Support

- [x] Custom content
- [x] Arrow direction
- [x] Hidden Arrow
- [x] Custom border
- [x] Custom shadow
- [x] Custom transition animation
- [x] Custom list item
- [x] Dark mode (iOS13+)
- [x] Global appearance
- [ ] Arrow direction priority
- [ ] List appends/removes item
- [ ] Compatible with screen rotation

## Requirements

* iOS 12+
* Swift 5
* Xcode 15+

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

```ruby
pod 'FSPopoverView'
```

#### [Carthage](https://github.com/Carthage/Carthage)

````bash
github "lifution/FSPopoverView"
````

#### [Swift Package Manager](https://swift.org/package-manager/)

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding FSPopoverView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```Swift
dependencies: [
    .package(url: "https://github.com/lifution/FSPopoverView.git")
]
```

#### Copy manually

Download or clone the repository, drag the folder `Source` into your project, and tick `Copy items if needed` and `Create groups`.

## Usage

* If you need to customize the content, use FSPopoverView, implements the dataSource and return the contents.
```Swift
let popoverView = FSPopoverView()
popoverView.dataSource = self
popoverView.present(fromBarItem: barItem)

// data source
extension viewController: FSPopoverViewDataSource {
    
    func backgroundView(for popoverView: FSPopoverView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }
    
    func contentView(for popoverView: FSPopoverView) -> UIView? {
        return contentView
    }
    
    func contentSize(for popoverView: FSPopoverView) -> CGSize {
        return .init(width: 100.0, height: 100.0)
    }
    
    func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets {
        return view.safeAreaInsets
    }
    
    func popoverViewShouldDismissOnTapOutside(_ popoverView: FSPopoverView) -> Bool {
        return true
    }
}

```
* If you need to display a list, use `FSPopoverListView`, which provides `FSPopoverListTextItem` by default. `FSPopoverListView` is data-driven. Inherits `FSPopoverListItem` and `FSPopoverListCell` if you need to customize the item.
```Swift
let features: [Feature] = [.copy, .message, .db, .qr, .settings]
let items: [FSPopoverListItem] = features.map { feature in
    let item = FSPopoverListTextItem()
    item.image = feature.image
    item.title = feature.title
    item.isSeparatorHidden = false
    item.selectedHandler = { item in
        guard let item = item as? FSPopoverListTextItem else {
            return
        }
        print(item.title ?? "")
    }
    item.updateLayout()
    return item
}
items.last?.isSeparatorHidden = true
let listView = FSPopoverListView()
listView.items = items
listView.present(fromRect: sender.frame.insetBy(dx: 0.0, dy: -6.0), in: view)
```
* Use `FSPopoverView.fs_appearance()` to customize default values for popover view.
```Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    do {
        let appearance = FSPopoverView.fs_appearance()
        appearance.showsArrow = false
        appearance.showsDimBackground = true
        ...
    }
    return true
}
```
* For more information on how to use, see the example project under the repository.

## License

FSPopoverView is available under the MIT license. [See the LICENSE](https://github.com/lifution/FSPopoverView/blob/master/LICENSE) file for more info.
