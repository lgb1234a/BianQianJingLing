//
//  AccountTipView.h
//  Project - B
//
//  Created by lcy on 15/10/20.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTipView : UIView


@property (strong, nonatomic)UITextField *incomeTextField;  // 收入
@property (strong, nonatomic)UITextField *outcomeTextField; // 支出
@property (strong, nonatomic)UITextView *descTextView;      // 明细
@property (assign, nonatomic)BOOL isOutcome;  // 是否填写的支出


@end
