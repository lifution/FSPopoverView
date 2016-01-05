

//
//  ViewController.m
//  Popover
//
//  Created by lifution on 16/1/5.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import "ViewController.h"
#import "PopoverView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}
- (IBAction)showPopover:(id)sender {
    
    UIButton *showBtn = sender;
    
    PopoverView *popoverView = [PopoverView new];
    popoverView.menuTitles   = @[@"扫一扫", @"加好友", @"创建讨论组", @"发送到电脑", @"面对面快传", @"收钱"];
    __weak __typeof(&*self)weakSelf = self;
    [popoverView showFromView:showBtn selected:^(NSInteger index) {
        weakSelf.label.text = popoverView.menuTitles[index];
    }];
}


- (IBAction)inShowPopover:(id)sender {
    
    UIButton *showBtn = sender;
    
    PopoverView *popoverView = [PopoverView new];
    popoverView.menuTitles   = @[@"扫一扫", @"加好友", @"创建讨论组", @"发送到电脑", @"面对面快传", @"收钱"];
    __weak __typeof(&*self)weakSelf = self;
    [popoverView showFromView:showBtn selected:^(NSInteger index) {
        weakSelf.label.text = popoverView.menuTitles[index];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
