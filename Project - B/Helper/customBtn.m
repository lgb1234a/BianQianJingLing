//
//  customBtn.m
//  Project - B
//
//  Created by lcy on 15/10/16.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "customBtn.h"
#import "MySingleTon.h"
@implementation customBtn

// 开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", NSStringFromCGPoint(self.center));
}

// 取消
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

// 结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 判定结束位置，在时间轴上，创建便条
    // 不在时间轴上，删除便条
    UITouch *touch = [touches anyObject];
    customBtn *btn = (customBtn *)touch.view;
    
    self.block(self.center, btn);
    
}

// 移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.moveBlock(self.center, self);
    UITouch *touch = [touches anyObject];
    UIButton *btn = (UIButton *)touch.view;
    
    btn.transform = CGAffineTransformIdentity;
    
    CGPoint p = self.center;
    CGPoint pointPre = [touch previousLocationInView:self];
    CGFloat x = p.x - pointPre.x;
    CGFloat y = p.y - pointPre.y;
    
    CGPoint point = [touch locationInView:self];
    CGFloat xNow = point.x + x;
    CGFloat YNow = point.y + y;
    
    CGPoint pointNow;
    if(_isOnLine && ![MySingleTon shareSingleTon].isEditting)
    {
        // 在时间轴上的便签只能上下拖拽，且高度不能超出时间轴的范围
        // 在内部移动
        if((CGRectGetMaxY(self.frame) < KScreen_Height * 0.2 + KScreen_Height * 0.7 - 40) && (CGRectGetMinY(self.frame) > KScreen_Height * 0.2 + 40))
        {
            pointNow = CGPointMake(p.x, YNow);
            
        }else if(CGRectGetMaxY(self.frame) >= KScreen_Height * 0.2 + KScreen_Height * 0.7 - 40) // 不超出下边界
        {
            if(point.y - pointPre.y < 0)
            {
                
                pointNow = CGPointMake(p.x, YNow);
            }else
            {
                pointNow = CGPointMake(p.x, KScreen_Height * 0.2 + KScreen_Height * 0.7 - 40);
            }
        }else if (CGRectGetMinY(self.frame) <= KScreen_Height * 0.2 + 40)
        { // 不超出上边界
            if(point.y - pointPre.y > 0)
            {
                pointNow = CGPointMake(p.x, YNow);
            }
            else
            {
                pointNow = CGPointMake(p.x, KScreen_Height * 0.2 + 40);
            }
        }
    }else
    {
        pointNow = CGPointMake(xNow, YNow);
    }
    self.center = pointNow;
}


@end
