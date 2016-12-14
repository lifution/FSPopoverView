# Popover
模拟QQ和微信消息页面的右上角弹窗效果<p>
所有效果如下图:<p>
![Alt text][image-5]<p>
该弹窗有两种风格:<p>
白色风格: `PopoverViewStyleDefault` (默认为此风格)<p>
![Alt text][image-1]<p>
黑色风格: `PopoverViewStyleDark`<p>
![Alt text][image-2]<p>
可以设置图片也可以不设置图片:
```objc 
- (IBAction)showWithoutImage:(UIButton *)sender {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"Title" handler:^(PopoverAction *action) {
        // 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
    }];
    ...
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:@[action1, ...]];
}
```
![Alt text][image-4]<p>
也可以设置在弹出窗口时显示背景阴影层:
```objc
- (IBAction)rightButtonAction:(UIButton *)sender {
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToView:sender withActions:@[...]];
}
```
![Alt text][image-3]<p>
使用方法:
```objc 
// 附带左边图标的
PopoverAction *action1 = [PopoverAction actionWithImage:Image title:@"Title" handler:^(PopoverAction *action) {
    // 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
}];
// 纯标题的
PopoverAction *action1 = [PopoverAction actionWithTitle:@"Title" handler:^(PopoverAction *action) {
        // 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
    }];
...
PopoverView *popoverView = [PopoverView popoverView];
//popoverView.showShade = YES; // 显示阴影背景
//popoverView.style = PopoverViewStyleDark; // 设置为黑色风格
//popoverView.hideAfterTouchOutside = NO; // 点击外部时不允许隐藏
[popoverView showToView:sender withActions:@[action1, ...]];
```
## LICENSE
PopoverView is available under the MIT license. See the LICENSE file for more info.

[image-1]:http://oeysrv69b.bkt.clouddn.com/1.png
[image-2]:http://oeysrv69b.bkt.clouddn.com/2.png
[image-3]:http://oeysrv69b.bkt.clouddn.com/3.png
[image-4]:http://oeysrv69b.bkt.clouddn.com/4.png
[image-5]:http://oeysrv69b.bkt.clouddn.com/Popover.gif

