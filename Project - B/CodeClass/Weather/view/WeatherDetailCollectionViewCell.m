//
//  WeatherDetailCollectionViewCell.m
//  Project - B
//
//  Created by lanou on 15/10/29.
//  Copyright © 2015年 lcy. All rights reserved.
//

#import "WeatherDetailCollectionViewCell.h"

@implementation WeatherDetailCollectionViewCell

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
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weather"]];
        self.backgroundView = imgView;
        
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 110, KScreen_Height / 2 - 70, 40, 20)];
        weekLabel.text = @"星期:";
        [self.contentView addSubview:weekLabel];
        _weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 60, KScreen_Height / 2 - 70, 140, 20)];
        [self.contentView addSubview:_weekLabel];
        
        UILabel *weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 110, KScreen_Height / 2 - 40, 40, 20)];
        weatherLabel.text = @"天气:";
        [self.contentView addSubview:weatherLabel];
        _weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 60, KScreen_Height / 2 - 40, 140, 20)];
        [self.contentView addSubview:_weatherLabel];
        
        UILabel *temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 110, KScreen_Height / 2 - 10, 40, 20)];
        temperatureLabel.text = @"温度:";
        [self.contentView addSubview:temperatureLabel];
        _temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 60, KScreen_Height / 2 - 10, 140, 20)];
        [self.contentView addSubview:_temperatureLabel];
        
        UILabel *windLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 110, KScreen_Height / 2 + 20, 40, 20)];
        windLabel.text = @"风速:";
        [self.contentView addSubview:windLabel];
        
        _windLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreen_Width / 2 - 60, KScreen_Height / 2 + 20, 140, 20)];
        [self.contentView addSubview:_windLabel];
        
    }
    
    return self;
    
}




@end
