//
//  WeatherTipView.m
//  Project - B
//
//  Created by lcy on 15/10/20.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "WeatherTipView.h"
#import "UIColor+ThemeColor.h"
@implementation WeatherTipView

// 初始化frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.layer.cornerRadius = 5;
        self.backgroundView.backgroundColor = [UIColor colorWithWeather];
        [self addSubview:self.backgroundView];
        
        UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 30)];
        city.text = @"城市";
        [self.backgroundView addSubview:city];
        
        self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, 80, 30)];
        self.cityTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.backgroundView addSubview:self.cityTextField];
        
        _searchWeather = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchWeather setTitle:@"search" forState:UIControlStateNormal];
        [_searchWeather setTitleColor:[UIColor colorWithRed:0.183 green:0.657 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
        _searchWeather.frame = CGRectMake(180, 10, 60, 30);
//        [_searchWeather addTarget:self action:@selector(searchWeather:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:_searchWeather];
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 260, 30)];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.dateLabel];
        
        self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 120, 30)];
        [self.backgroundView addSubview:self.temperature];
        
        self.locatedCity = [[UILabel alloc] initWithFrame:CGRectMake(130, 110, 120, 30)];
        [self.backgroundView addSubview:self.locatedCity];
        
        self.weather = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 120, 30)];
        [self.backgroundView addSubview:self.weather];
        
        self.uv_index = [[UILabel alloc] initWithFrame:CGRectMake(130, 160, 120, 30)];
        [self.backgroundView addSubview:self.uv_index];
        
        self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, 260, 30)];
        self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.backgroundView addSubview:self.currentTimeLabel];
        
        self.currentTemp = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, 120, 30)];
        [self.backgroundView addSubview:self.currentTemp];
        
        self.humidity = [[UILabel alloc] initWithFrame:CGRectMake(130, 260, 120, 30)];
        [self.backgroundView addSubview:self.humidity];
    }
    return self;
}




@end
