//
//  RestdayTipView.h
//  Project - B
//
//  Created by lcy on 15/10/21.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestdayTipView : UIView

@property (nonatomic, strong)UITextField *yearTextField;   // 输入年
@property (nonatomic, strong)UITextField *monthTextField;  // 月
@property (nonatomic, strong)UITextField *dayTextField;    // 日
@property (nonatomic, strong)UITextView  *descripTextView; // 日期描述

@end
