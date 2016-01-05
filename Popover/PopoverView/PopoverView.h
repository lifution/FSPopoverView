//
//  PopoverView.h
//  Popover
//
//  Created by lifution on 16/1/5.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopoverBlock)(NSInteger index);

@interface PopoverView : UIView

// 菜单列表集合
@property (nonatomic, copy) NSArray *menuTitles;

/*!
 *  @author lifution
 *
 *  @brief 显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected;

@end


@interface PopoverArrow : UIView

@end