//
//  WeatherTipView.h
//  Project - B
//
//  Created by lcy on 15/10/20.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTipView : UIView

@property (nonatomic, strong)UIButton *searchWeather;    // 搜索按钮
@property (strong, nonatomic)UIView *backgroundView;      // 背景
@property (nonatomic, strong)UITextField *cityTextField;    // 城市
@property (nonatomic, copy)NSString *cityIp;             // 城市IP

@property (nonatomic, strong)UILabel *dateLabel;         // 天气的时间label
@property (nonatomic, strong)UILabel *temperature;       // 温度
@property (nonatomic, strong)UILabel *locatedCity;              // 当前城市
@property (nonatomic, strong)UILabel *weather;           // 天气
@property (nonatomic, strong)UILabel *uv_index;          // 紫外线强度
@property (nonatomic, strong)UILabel *currentTemp;       // 当前温度
@property (nonatomic, strong)UILabel *currentTimeLabel;  // 时间Label
@property (nonatomic, strong)UILabel *humidity;          // 污染指数


@end
