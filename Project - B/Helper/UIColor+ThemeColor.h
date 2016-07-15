//
//  UIColor+ThemeColor.h
//  Project - B demo
//
//  Created by lcy on 15/10/14.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ThemeColor)

// 对应颜色
+ (UIColor *)colorOfOptionWithIndex:(NSInteger)index;

// 颜色以及透明度
+ (UIColor *)colorWithIndex:(NSInteger)index alpha:(CGFloat)alpha;

// 天气
+ (UIColor *)colorWithWeather;

// 天气阴影颜色
+ (CGColorRef)weatherShadowColor;

// 提醒
+ (UIColor *)colorWithNotification;

// 提醒阴影颜色
+ (CGColorRef)notificationShadowColor;

// 笔记
+ (UIColor *)colorWithNote;

// 笔记阴影颜色
+ (CGColorRef)noteShadowColor;

// 账本
+ (UIColor *)colorWithAccount;

// 账本阴影颜色
+ (CGColorRef)accountShadowColor;

// 倒数日
+ (UIColor *)colorWithRestDay;

// 倒数日阴影颜色
+ (CGColorRef)restDayShadowColor;

// 书签钉颜色
+ (UIColor *)colorWithBookNails;

// 书签钉阴影颜色
+ (CGColorRef)bookNailsShadowColor;

// 高亮书签钉
+ (UIColor *)colorWithBookNailsHighLighted;

// 文本颜色
+ (UIColor *)colorOfTextWithContentColor:(UIColor *)contentColor;

// 边界颜色
+ (UIColor *)colorOfBorderWithContentColor:(UIColor *)contentColor;

// 时间轴颜色
+ (UIColor *)colorWIthTimeLine;

// 主题色
+ (UIColor *)colorWithTheme;

// 取消的颜色
+ (UIColor *)colorAtLeft;

// 确定的颜色
+ (UIColor *)colorAtRight;

@end
