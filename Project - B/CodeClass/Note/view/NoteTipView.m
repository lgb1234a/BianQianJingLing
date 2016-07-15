//
//  NoteTipView.m
//  Project - B
//
//  Created by lcy on 15/10/20.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "NoteTipView.h"
#import "UIColor+ThemeColor.h"

@interface NoteTipView () <UITextViewDelegate>

@property (strong, nonatomic)UILabel *maskLabel;            // placeHolder

@end

@implementation NoteTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:self.bounds];
        self.textView.delegate = self;
        [self.textView setTextColor:[UIColor colorWithRed:0.701 green:0.973 blue:0.128 alpha:1.000]];
        [self.textView setFont:[UIFont systemFontOfSize:14]];
        self.textView.layer.cornerRadius = 5;
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.backgroundColor = [UIColor colorWithNote];
//        self.textView.textColor = [UIColor colorOfTextWithContentColor:[UIColor colorWithTheme]];
        [self addSubview:self.textView];
        
        self.maskLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, self.textView.frame.size.width - 17, 20)];
        self.maskLabel.text = @"在这里输入笔记哦！";
        self.maskLabel.textColor = [UIColor yellowColor];
        [self.maskLabel setFont:[UIFont systemFontOfSize:14]];
        self.maskLabel.enabled = NO;//lable必须设置为不可用
        self.maskLabel.backgroundColor = [UIColor clearColor];
        [self.textView addSubview:self.maskLabel];
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
