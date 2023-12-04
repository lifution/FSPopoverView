# FSPopoverView

[![Version Status](https://img.shields.io/cocoapods/v/FSPopoverView.svg)](https://cocoapods.org/pods/FSPopoverView)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![license MIT](https://img.shields.io/cocoapods/l/FSPopoverView.svg)](https://github.com/lifution/Popover/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/FSPopoverView.svg)](https://github.com/lifution/FSPopoverView/blob/master/README.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### [中文介绍](https://github.com/lifution/FSPopoverView/blob/master/README_CN.md)

A library to present popovers.

## Demo

|<div style="width: 25%">**Custome content**</div>|<div style="width: 25%">**List (Light)**</div>|<div style="width: 25%">**List (Dark)**</div>|<div style="width: 25%">**List (Custom item)**</div>|
|:--:|:--:|:--:|:--:|
|<div style="width: 25%"><img src="Screenshots/custom.PNG"></div>|<div style="width: 25%"><img src="Screenshots/list_light.PNG"></div>|<div style="width: 25%"><img src="Screenshots/list_dark.PNG"></div>|<div style="width: 25%"><img src="Screenshots/custom_item.PNG"></div>|
|**List (Horizontal layout)**|
|<img src="Screenshots/menu.PNG">|

## Support

- [x] Customization
- [x] Arrow direction
- [x] Hidden Arrow
- [x] Custom border
- [x] Custom shadow
- [x] Custom transition animation
- [x] Custom list item
- [x] Dark mode
- [x] Global appearance
- [ ] Arrow direction priority
- [ ] List appends/removes item

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

#### Copy manual

Download or clone the repository, drag the folder `FSPopoverView` into your project, and tick `Copy items if needed` and `Create groups`.

## Usage

* If you need to customize the content, use FSPopoverView, implements the dataSource and return the corresponding content.
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
* If you need to display a list, use FSPopoverListView, which provides FSPopoverListTextItem by default. Inherits FSPopoverListItem and FSPopoverListCell if you need to customize the item.
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

FSPopoverView is available under the MIT license. [See the LICENSE](https://github.com/lifution/Popover/blob/master/LICENSE) file for more info.
