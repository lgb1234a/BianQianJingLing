//
//  RestdayDetailCollectionViewCell.m
//  Project - B
//
//  Created by 王渊博 on 15/10/29.
//  Copyright © 2015年 lcy. All rights reserved.
//

#import "RestdayDetailCollectionViewCell.h"

@interface RestdayDetailCollectionViewCell ()

@property(nonatomic,strong)UILabel *oneLabel;   // 距离

@end


@implementation RestdayDetailCollectionViewCell

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
    if (self) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restDay"]];
        self.backgroundView = imgView;
        
        _oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width/2 - 20, KScreen_Height/2 - 150, 40, 30)];
        _oneLabel.textAlignment = NSTextAlignmentCenter;
        _oneLabel.font = [UIFont systemFontOfSize:15];
//        _oneLabel.backgroundColor = [UIColor grayColor];
        _oneLabel.text = @"距离";
        
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width/2-40, KScreen_Height/2 - 40, 80, 30)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:16];
//        _descLabel.backgroundColor = [UIColor redColor];
//        _secondLabel.text=@"新年";
        
        _daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width/2 - 100, KScreen_Height/2 + 10, 200, 40)];
        _daysLabel.textAlignment = NSTextAlignmentCenter;
        _daysLabel.font = [UIFont systemFontOfSize:16];
//        _daysLabel.backgroundColor = [UIColor redColor];
//        _daysLabel.text=@"64";
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width/2-100, KScreen_Height/2 - 100, 200, 20)];
        _dateLabel.textAlignment=NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:16];
//        _dateLabel.backgroundColor = [UIColor redColor];
//        _timeLabel.text=@"2015-01-01  周五";
        
        
        [self.contentView addSubview:_oneLabel];
        [self.contentView addSubview:_descLabel];
        [self.contentView addSubview:_daysLabel];
        [self.contentView addSubview:_dateLabel];
        
    }
    return self;
}





@end
