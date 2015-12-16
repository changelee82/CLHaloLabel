//
//  CLHaloLabel.h
//  CLHaloLabel
//
//  Created by 李辉 on 15/12/16.
//  Copyright © 2015年 李辉. All rights reserved.
//  https://github.com/changelee82/CLHaloLabel
//
//  此Label不能设置背景色，否则无法显示动画效果
//

#import <UIKit/UIKit.h>


/** 拥有光晕扫过效果的Label */
@interface CLHaloLabel : UILabel


/** 光晕循环一次的持续时间，默认循环时间为3秒 */
@property (nonatomic, assign) CGFloat haloDuration;

/** 光晕宽度占Label宽度的百分比，默认0.5 */
@property (nonatomic, assign) CGFloat haloWidth;

/** 光晕颜色，默认白色 */
@property (nonatomic, strong) UIColor *haloColor;

/** 是否执行动画，默认为NO */
@property (nonatomic, assign, getter = isAnimated) BOOL animated;


@end
