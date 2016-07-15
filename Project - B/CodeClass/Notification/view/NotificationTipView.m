//
//  NotificationTipView.m
//  Project - B
//
//  Created by lcy on 15/10/22.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "NotificationTipView.h"
#import "UIColor+ThemeColor.h"
@interface NotificationTipView () <UITextViewDelegate>

@property (strong, nonatomic)UIView *backgroundView;      // 背景
@property (strong, nonatomic)UILabel *maskLabel;            // placeHolder

@end


@implementation NotificationTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.layer.cornerRadius = 5;
        self.backgroundView.backgroundColor = [UIColor colorWithNotification];
        [self addSubview:self.backgroundView];
        
        _chooseDate = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseDate.frame = CGRectMake(0, 10, 260, 30);
        [_chooseDate setTitle:@"选择提醒时间" forState:UIControlStateNormal];
        _chooseDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:_chooseDate];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 260, 30)];
        _timeLabel.text = @"未知时间";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
        
        _descripTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 240, 200)];
        _descripTextView.delegate = self;
        _descripTextView.layer.cornerRadius = 5.0;
        _descripTextView.backgroundColor = [UIColor colorWithRed:0.452 green:0.744 blue:0.965 alpha:1.000];
        [self addSubview:_descripTextView];
        
        self.maskLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, self.descripTextView.frame.size.width - 17, 20)];
        self.maskLabel.text = @"在这里输入提醒内容哦！";
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
