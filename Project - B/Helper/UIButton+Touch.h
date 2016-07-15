//
//  UIButton+Touch.h
//  Project - B
//
//  Created by lcy on 15/10/16.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Touch)

// 创建自定义frame的Btn
+ (UIButton *)buttonWithFrame:(CGRect)frame;

// shadowOffset
- (void)setShadowOffset;

// shadowOpacity
- (void)setShadowOpacity;

// shadowColor
- (void)setShadowColor:(CGColorRef)color;

// cornerRadius
- (void)setCornerRadius:(CGFloat)cornerRadius;

@end
