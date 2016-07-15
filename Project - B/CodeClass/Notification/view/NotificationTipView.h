//
//  NotificationTipView.h
//  Project - B
//
//  Created by lcy on 15/10/22.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTipView : UIView

@property (nonatomic, strong)UIButton *chooseDate; // 点击选择日期
@property (nonatomic, strong)UILabel *timeLabel;   // 所选时间
@property (nonatomic, strong)UITextView  *descripTextView; // 提醒记录

@end
