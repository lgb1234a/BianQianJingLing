//
//  UIButton+Touch.m
//  Project - B
//
//  Created by lcy on 15/10/16.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "UIButton+Touch.h"

@implementation UIButton (Touch)

// 创建自定义frame的Btn
+ (UIButton *)buttonWithFrame:(CGRect)frame
{
    return [[UIButton alloc] initWithFrame:frame];
}

// shadowOffset
- (void)setShadowOffset
{
    self.layer.shadowOffset  = CGSizeMake(3, 5);
}

// shadowOpacity
- (void)setShadowOpacity
{
    self.layer.shadowOpacity = 0.8;
}

// shadowColor
- (void)setShadowColor:(CGColorRef)color
{
    self.layer.shadowColor = color;
    
}

// cornerRadius
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius  = cornerRadius;
}

@end
