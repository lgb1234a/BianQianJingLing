//
//  AccountDetailCollectionViewCell.m
//  Project - B
//
//  Created by 王渊博 on 15/10/29.
//  Copyright © 2015年 lcy. All rights reserved.
//

#import "AccountDetailCollectionViewCell.h"

@implementation AccountDetailCollectionViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weather"]];
        self.backgroundView = imgView;
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, KScreen_Height / 5, KScreen_Width - 120, 30)];
       
        [self.contentView addSubview:_moneyLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, KScreen_Height / 5 + 50, KScreen_Width - 120, 30)];
       
        [self.contentView addSubview:_typeLabel];
        
        _contentTV = [[UITextView alloc] initWithFrame:CGRectMake(60, KScreen_Height / 5 + 100, KScreen_Width - 120, KScreen_Height / 5 * 4 - 250)];
        _contentTV.layer.cornerRadius = 5;
        _contentTV.backgroundColor = [UIColor clearColor];
        _contentTV.editable = NO;
        _contentTV.userInteractionEnabled = NO;
        [self.contentView addSubview:_contentTV];
    }
    return self;
}




@end
