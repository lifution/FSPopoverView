//
//  PopoverView.h
//  Popover
//
//  Created by lifution on 16/1/5.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverAction.h"

@interface PopoverView : UIView

@property (nonatomic, assign) BOOL hideAfterTouchOutside; ///< 是否开启点击外部隐藏弹窗, 默认为YES.
@property (nonatomic, assign) BOOL showShade; ///< 是否显示阴影, 如果为YES则弹窗背景为半透明的阴影层, 否则为透明, 默认为NO.
@property (nonatomic, assign) PopoverViewStyle style; ///< 弹出窗风格, 默认为 PopoverViewStyleDefault(白色).

+ (instancetype)popoverView;

/*! @brief 指向指定的View来显示弹窗
 *  @param pointView 箭头指向的View
 *  @param actions   动作对象集合<PopoverAction>
 */
- (void)showToView:(UIView *)pointView withActions:(NSArray<PopoverAction *> *)actions;

/*! @brief 指向指定的点来显示弹窗
 *  @param toPoint 箭头指向的点(这个点的坐标需按照keyWindow的坐标为参照)
 *  @param actions 动作对象集合<PopoverAction>
 */
- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<PopoverAction *> *)actions;

@end
