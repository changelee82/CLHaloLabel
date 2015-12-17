//
//  CLHaloLabel.m
//  CLHaloLabel
//
//  Created by 李辉 on 15/12/16.
//  Copyright © 2015年 李辉. All rights reserved.
//  https://github.com/changelee82/CLHaloLabel
//

#import "CLHaloLabel.h"
#import <CoreText/CoreText.h>


/** 默认光晕循环一次的持续时间 */
static const NSTimeInterval kHaloDuration = 3.0f;

/** 默认光晕宽度 */
static const CGFloat kHaloWidth = 0.5f;

/** 默认光晕颜色 */
#define kHaloColor  [UIColor whiteColor]

/** 光晕动画ID */
static NSString *const kAnimationKey = @"CLHaloLabelAnimation";



@interface CLHaloLabel ()

/** 文字层 */
@property (nonatomic, strong) CATextLayer *textLayer;

/** 动画步调 */
@property (nonatomic, copy) NSString *animationPacing;

/** 动画步调可选的选项
kCAMediaTimingFunctionLinear    // 线性动画
kCAMediaTimingFunctionEaseIn    // 快速进入动画
kCAMediaTimingFunctionEaseOut   // 快速出来动画
kCAMediaTimingFunctionEaseInEaseOut // 快速进入出来动画
kCAMediaTimingFunctionDefault   // 默认动画是curve动画，也就是曲线动画
*/

@end



@implementation CLHaloLabel

@synthesize animated = _animated;


#pragma mark - 初始化

/** 初始化方法，用于从代码中创建的类实例 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 初始化方法，用于从代码中创建的类实例 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 初始化方法，用于从xib文件中载入的类实例 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 默认的初始化方法 */
- (void)defaultInit
{
    // 设置默认的光晕颜色、光晕持续时间、光晕宽度
    _haloColor    = kHaloColor;
    _haloDuration = kHaloDuration;
    _haloWidth    = kHaloWidth;
    _animationPacing = kCAMediaTimingFunctionEaseInEaseOut;
    
    // 设置渐变层参数
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor  = [super.textColor CGColor];
    gradientLayer.startPoint       = CGPointMake(-_haloWidth, 0);
    gradientLayer.endPoint         = CGPointMake(0, 0);
    gradientLayer.colors           = @[(id)[self.textColor CGColor],
                                       (id)[self.haloColor CGColor],
                                       (id)[self.textColor CGColor]];
    
    // 设置文字层参数
    self.textLayer                    = [CATextLayer layer];
    self.textLayer.backgroundColor    = [[UIColor clearColor] CGColor];
    self.textLayer.contentsScale      = [[UIScreen mainScreen] scale];
    self.textLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.textLayer.frame              = self.bounds;
    self.textLayer.anchorPoint        = CGPointZero;
    
    // 设置Label参数，针对从xib文件中载入的Label，需要调用self的属性设置方法
    [self setFont:          super.font];
    [self setTextAlignment: super.textAlignment];
    [self setText:          super.text];
    [self setTextColor:     super.textColor];
    
    // 将文字层作为蒙层，覆盖到渐变层上
    gradientLayer.mask = self.textLayer;
    
    // 开启动画
    self.animated = YES;
}


#pragma mark - 重载类方法

/** 重写Label的layer为渐变层 */
+ (Class)layerClass
{
    return [CAGradientLayer class];
}

/** 停止重绘，使用文字层绘制 */
- (void)drawRect:(CGRect)rect {}


#pragma mark - 布局子层

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.textLayer.frame = self.layer.bounds;
}


#pragma mark - 属性

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

/** 光晕持续时间 */
- (void)setHaloDuration:(CGFloat)haloDuration
{
    _haloDuration = haloDuration;
    if(_animated)
    {
        [self stopAnimating];
        [self startAnimating];
    }
}

/** 光晕宽度 */
- (void)setHaloWidth:(CGFloat)haloWidth
{
    _haloWidth = haloWidth;
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.startPoint       = CGPointMake(-_haloWidth, 0);
    
    if(_animated)
    {
        [self stopAnimating];
        [self startAnimating];
    }
}

/** 文字颜色 */
- (UIColor *)textColor
{
    // 文字颜色为渐变层背景色
    UIColor *textColor = [UIColor colorWithCGColor:self.layer.backgroundColor];
    if (!textColor)
    {
        textColor = [super textColor];
    }
    return textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    UIColor *haloColor = self.haloColor ? self.haloColor : kHaloColor;
    
    // 重设渐变层背景色和渐变层颜色表
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor  = [textColor CGColor];
    gradientLayer.colors           = @[(id)[textColor CGColor],
                                       (id)[haloColor CGColor],
                                       (id)[textColor CGColor]];
    
    [self setNeedsDisplay];
}

/** 文字 */
- (NSString *)text
{
    // 返回文字层文字
    return self.textLayer.string;
}

- (void)setText:(NSString *)text
{
    self.textLayer.string = text;
    [self setNeedsDisplay];
}

/** 文字字体 */
- (UIFont *)font
{
    CTFontRef ctFont    = self.textLayer.font;
    NSString *fontName  = (__bridge_transfer NSString *)CTFontCopyName(ctFont, kCTFontPostScriptNameKey);
    CGFloat fontSize    = CTFontGetSize(ctFont);
    return [UIFont fontWithName:fontName size:fontSize];
}

- (void)setFont:(UIFont *)font
{
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)(font.fontName), font.pointSize, &CGAffineTransformIdentity);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = font.pointSize;
    CFRelease(fontRef);
    [self setNeedsDisplay];
}

/** 文字对齐方式 */
- (NSTextAlignment)textAlignment
{
    return [self.class UITextAlignmentFromCAAlignment:self.textLayer.alignmentMode];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.textLayer.alignmentMode = [self.class CAAlignmentFromUITextAlignment:textAlignment];
}

+ (NSString *)CAAlignmentFromUITextAlignment:(NSTextAlignment)textAlignment
{
    switch (textAlignment) {
        case NSTextAlignmentLeft:   return kCAAlignmentLeft;
        case NSTextAlignmentCenter: return kCAAlignmentCenter;
        case NSTextAlignmentRight:  return kCAAlignmentRight;
        default:                    return kCAAlignmentNatural;
    }
}

+ (NSTextAlignment)UITextAlignmentFromCAAlignment:(NSString *)alignment
{
    if ([alignment isEqualToString:kCAAlignmentLeft])       return NSTextAlignmentLeft;
    if ([alignment isEqualToString:kCAAlignmentCenter])     return NSTextAlignmentCenter;
    if ([alignment isEqualToString:kCAAlignmentRight])      return NSTextAlignmentRight;
    if ([alignment isEqualToString:kCAAlignmentNatural])    return NSTextAlignmentLeft;
    return NSTextAlignmentLeft;
}


#pragma mark - 光晕动画

- (BOOL) isAnimated
{
    return _animated;
}

- (void) setAnimated:(BOOL)animated
{
    _animated = animated;
    if (_animated)
        [self startAnimating];
    else
        [self stopAnimating];
}

- (void)setHaloColor:(UIColor *)haloColor
{
    _haloColor = haloColor;
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors           = @[(id)[self.textColor CGColor],
                                       (id)[self.haloColor CGColor],
                                       (id)[self.textColor CGColor]];
    [self setNeedsDisplay];
}

/** 开启动画 */
- (void)startAnimating
{
    static NSString *gradientStartPointKey = @"startPoint";
    static NSString *gradientEndPointKey = @"endPoint";
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    if([gradientLayer animationForKey:kAnimationKey] == nil)
    {
        // 通过不断改变渐变的起止范围，来实现光晕效果
        CABasicAnimation *startPointAnimation = [CABasicAnimation animationWithKeyPath:gradientStartPointKey];
        startPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 0)];
        startPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:_animationPacing];
        
        CABasicAnimation *endPointAnimation = [CABasicAnimation animationWithKeyPath:gradientEndPointKey];
        endPointAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1 + _haloWidth, 0)];
        endPointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:_animationPacing];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[startPointAnimation, endPointAnimation];
        group.duration = _haloDuration;
        group.timingFunction = [CAMediaTimingFunction functionWithName:_animationPacing];
        group.repeatCount = HUGE_VALF;
        
        [gradientLayer addAnimation:group forKey:kAnimationKey];
    }
}

/** 结束动画 */
- (void)stopAnimating
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    if([gradientLayer animationForKey:kAnimationKey])
        [gradientLayer removeAnimationForKey:kAnimationKey];
}

@end
