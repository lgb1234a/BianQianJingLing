//
//  RestdayTipView.m
//  Project - B
//
//  Created by lcy on 15/10/21.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "RestdayTipView.h"
#import "UIColor+ThemeColor.h"
@interface RestdayTipView () <UITextViewDelegate>

@property (strong, nonatomic)UIView *backgroundView;      // 背景
@property (strong, nonatomic)UILabel *maskLabel;            // placeHolder

@end

@implementation RestdayTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.layer.cornerRadius = 5;
        self.backgroundView.backgroundColor = [UIColor colorWithRestDay];
        [self addSubview:self.backgroundView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 260, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"纪念日(倒数日)：";
        [self addSubview:label];
        
        _yearTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 60, 30)];
        _yearTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_yearTextField];
        
        UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 50, 30, 30)];
        yearLabel.text = @"年";
        [self addSubview:yearLabel];
        
        _monthTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 50, 40, 30)];
        _monthTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_monthTextField];
        
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 50, 30, 30)];
        monthLabel.text = @"月";
        [self addSubview:monthLabel];
        
        _dayTextField = [[UITextField alloc] initWithFrame:CGRectMake(190, 50, 40, 30)];
        _dayTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_dayTextField];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 50, 30, 30)];
        dayLabel.text = @"日";
        [self addSubview:dayLabel];
        
        _descripTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 240, 200)];
        _descripTextView.layer.cornerRadius = 5.0;
        _descripTextView.delegate = self;
        _descripTextView.backgroundColor = [UIColor colorWithRed:1.000 green:0.739 blue:0.915 alpha:1.000];
        [self addSubview:_descripTextView];
        
        self.maskLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, self.descripTextView.frame.size.width - 17, 20)];
        self.maskLabel.text = @"在这里输入剩余日介绍哦！";
        self.maskLabel.textColor = [UIColor yellowColor];
        [self.maskLabel setFont:[UIFont systemFontOfSize:14]];
        self.maskLabel.enabled = NO;//lable必须设置为不可用
        self.maskLabel.backgroundColor = [UIColor clearColor];
        [self.descripTextView addSubview:self.maskLabel];
    }
    return self;
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
