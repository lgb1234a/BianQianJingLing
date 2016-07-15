//
//  UIColor+ThemeColor.m
//  Project - B demo
//
//  Created by lcy on 15/10/14.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "UIColor+ThemeColor.h"
#import "AppDelegate.h"
@implementation UIColor (ThemeColor)


// 对应颜色
+ (UIColor *)colorOfOptionWithIndex:(NSInteger)index
{
    NSArray *colorArr = @[[UIColor colorWithWeather], [UIColor colorWithNotification], [UIColor colorWithNote], [UIColor colorWithAccount], [UIColor colorWithRestDay]];
    return colorArr[index];
}

// 颜色以及透明度
+ (UIColor *)colorWithIndex:(NSInteger)index alpha:(CGFloat)alpha
{
    
    UIColor *color = [UIColor colorOfOptionWithIndex:index];
    
    UIColor *indexColor = [color colorWithAlphaComponent:alpha];
    return indexColor;
}

// 天气
+ (UIColor *)colorWithWeather
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
//        return [UIColor blackColor];
    }
    return [UIColor colorWithRed:0.839 green:0.337 blue:0.094 alpha:1.000];
    
}

+ (CGColorRef)weatherShadowColor
{
    return [UIColor colorWithWhite:0.061 alpha:1.000].CGColor;
}

// 提醒
+ (UIColor *)colorWithNotification
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
//        return [UIColor blackColor];
    }
    return [UIColor colorWithRed:0.671 green:0.392 blue:0.915 alpha:1.000];
}

+ (CGColorRef)notificationShadowColor
{
    return [UIColor colorWithWhite:0.173 alpha:1.000].CGColor;
}

// 笔记
+ (UIColor *)colorWithNote
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        
    }
    return [UIColor colorWithRed:0.097 green:0.449 blue:0.669 alpha:1.000];
}

+ (CGColorRef)noteShadowColor
{
    return [UIColor colorWithWhite:0.213 alpha:1.000].CGColor;
}

// 账本
+ (UIColor *)colorWithAccount
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        
    }
    return [UIColor colorWithRed:0.980 green:0.427 blue:0.592 alpha:1.000];
}

+ (CGColorRef)accountShadowColor
{
    return [UIColor colorWithWhite:0.398 alpha:1.000].CGColor;

}

// 倒数日
+ (UIColor *)colorWithRestDay
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        
    }
    return [UIColor colorWithRed:0.830 green:0.905 blue:0.067 alpha:1.000];
}

+ (CGColorRef)restDayShadowColor
{
    return [UIColor colorWithWhite:0.507 alpha:1.000].CGColor;
}

// 书签钉颜色
+ (UIColor *)colorWithBookNails
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        
    }
    return [UIColor colorWithRed:246 / 255.0 green:222 / 255.0 blue:200 / 255.0 alpha:1];
}

+ (CGColorRef)bookNailsShadowColor
{
    return [UIColor blackColor].CGColor;
}

// 高亮书签钉
+ (UIColor *)colorWithBookNailsHighLighted
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        
    }
    return [UIColor colorWithRed:0.004 green:0.098 blue:0.008 alpha:1.000];
}

// 文本颜色
+ (UIColor *)colorOfTextWithContentColor:(UIColor *)contentColor
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        [UIColor colorWithRed:195 / 255.0 green:214 / 255.0 blue:155 / 255.0 alpha:1];
    }
    return [UIColor blackColor];
}

// 边界颜色
+ (UIColor *)colorOfBorderWithContentColor:(UIColor *)contentColor
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        
    }
    return [UIColor colorWithRed:0.869 green:0.956 blue:0.851 alpha:1.000];
}

// 时间轴颜色
+ (UIColor *)colorWIthTimeLine
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        return [UIColor colorWithRed:0.349 green:0.000 blue:0.004 alpha:1.000];
    }
    return [UIColor colorWithRed:0.607 green:0.636 blue:0.098 alpha:0.560];
}

// 主题色
+ (UIColor *)colorWithTheme
{
    // 夜间模式
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
    {
        return [UIColor colorWithWhite:0.180 alpha:1.000];
    }
    return [UIColor colorWithRed:0.914 green:0.724 blue:0.356 alpha:0.500];
}

+ (UIColor *)colorAtLeft
{
    return [UIColor colorWithRed:0.233 green:1.000 blue:0.794 alpha:1.000];
}

+ (UIColor *)colorAtRight
{
    return [UIColor greenColor];
}

@end
