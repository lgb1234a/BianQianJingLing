//
//  AccountTipView.m
//  Project - B
//
//  Created by lcy on 15/10/20.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "AccountTipView.h"
#import "UIColor+ThemeColor.h"
@interface AccountTipView () <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic)UIButton *addIncomeBtn;        // 增加一条收入
@property (strong, nonatomic)UIButton *addOutcomeBtn;       // 增加一条支出
@property (strong, nonatomic)UIView *backgroundView;
@property (strong, nonatomic)UILabel *maskLabel;            // placeHolder

@end


@implementation AccountTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.layer.cornerRadius = 5;
        self.backgroundView.backgroundColor = [UIColor colorWithAccount];
        [self addSubview:self.backgroundView];
        
        self.addIncomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addIncomeBtn.frame = CGRectMake(135, 15, 120, 30);
        [self.addIncomeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.addIncomeBtn setTitle:@"添加收入记录" forState:UIControlStateNormal];
        self.addIncomeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:self.addIncomeBtn];
        [self.addIncomeBtn addTarget:self action:@selector(willAddIncomeHistory) forControlEvents:UIControlEventTouchUpInside];
        
        self.addOutcomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addOutcomeBtn.frame = CGRectMake(5, 15, 120, 30);
        [self.addOutcomeBtn setTitleColor:[UIColor colorAtLeft] forState:UIControlStateNormal];
        [self.addOutcomeBtn setTitle:@"添加支出记录" forState:UIControlStateNormal];
        self.addOutcomeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:self.addOutcomeBtn];
        [self.addOutcomeBtn addTarget:self action:@selector(willAddOutcomeHistory) forControlEvents:UIControlEventTouchUpInside];
        
        [self willAddOutcomeHistory];
    }
    return self;
}


// 添加收入记录
- (void)willAddIncomeHistory
{
    self.isOutcome = NO;
    for(UIView *view in self.backgroundView.subviews)
    {
        [view removeFromSuperview];
    }
    UILabel *income = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 30)];
    income.text = @"收入金额";
    income.textColor = [UIColor blackColor];
    [income setFont:[UIFont systemFontOfSize:14]];
    self.incomeTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 50, 140, 30)];
    self.incomeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.incomeTextField.delegate = self;
    self.incomeTextField.returnKeyType = UIReturnKeyDone;
    self.incomeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.backgroundView addSubview:self.incomeTextField];
    [self.backgroundView addSubview:income];
    
    [self initDescTextView];
}

// 添加支出记录
- (void)willAddOutcomeHistory
{
    self.isOutcome = YES;
    for(UIView *view in self.backgroundView.subviews)
    {
        [view removeFromSuperview];
    }
    UILabel *outcome = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 30)];
    outcome.text = @"支出金额";
    outcome.textColor = [UIColor colorAtLeft];
    [outcome setFont:[UIFont systemFontOfSize:14]];
    self.outcomeTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 50, 140, 30)];
    self.outcomeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.outcomeTextField.delegate = self;
    self.outcomeTextField.returnKeyType = UIReturnKeyDone;
    self.outcomeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.backgroundView addSubview:self.outcomeTextField];
    [self.backgroundView addSubview:outcome];
    
    [self initDescTextView];
}

// 创建收支详情

- (void)initDescTextView
{
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    desc.textColor = [UIColor colorWithNotification];
    desc.text = @"详情记录";
    [self.backgroundView addSubview:desc];
    
    self.descTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 140, 230, 150)];
    self.descTextView.delegate = self;
    self.descTextView.layer.cornerRadius = 5;
    self.descTextView.showsVerticalScrollIndicator = NO;
    self.descTextView.backgroundColor = [UIColor colorWithTheme];
    [self.backgroundView addSubview:self.descTextView];
    
    
    self.maskLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, self.descTextView.frame.size.width - 17, 20)];
    self.maskLabel.text = @"在这里输入收支详情哦！";
    self.maskLabel.textColor = [UIColor yellowColor];
    [self.maskLabel setFont:[UIFont systemFontOfSize:14]];
    self.maskLabel.enabled = NO;//lable必须设置为不可用
    self.maskLabel.backgroundColor = [UIColor clearColor];
    [self.descTextView addSubview:self.maskLabel];
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.maskLabel.text = @"在此输入内容哦！";
    }else{
        self.maskLabel.text = @"";
    }
}

@end
