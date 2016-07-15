//
//  customBtn.h
//  Project - B
//
//  Created by lcy on 15/10/16.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class customBtn;
typedef void(^tipsBlock)(CGPoint center, customBtn *touchBtn);
typedef void(^moveBlock)(CGPoint center, customBtn *touchBtn);
@interface customBtn : UIButton

@property (copy, nonatomic)tipsBlock block;  // touchEnd
@property (copy, nonatomic)moveBlock moveBlock; // touchMove
@property (assign, nonatomic)BOOL isOnLine;   // 是否在时间轴上
@property (assign, nonatomic)NSUInteger indexOfTip; // 每个便签在对应类别下的索引
@property (copy, nonatomic)NSString *buildDate;  // 标签创建日期，用于排序时间轴上的标签

@end
