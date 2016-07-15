//
//  TodayTemperatureModel.h
//  Project - B
//
//  Created by lcy on 15/10/19.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayTemperatureModel : NSObject

@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *date_y;           // 日期
@property (nonatomic, copy)NSString *dressing_advice;  // 穿衣建议
@property (nonatomic, copy)NSString *dressing_index;   // 穿着舒适度
@property (nonatomic, copy)NSString *exercise_index;   // 运动指数
@property (nonatomic, copy)NSString *temperature;      // 今日温度
@property (nonatomic, copy)NSString *travel_index;     // 旅游指数
@property (nonatomic, copy)NSString *uv_index;         // 紫外线指数
@property (nonatomic, copy)NSString *wash_index;       // 洗衣指数
@property (nonatomic, copy)NSString *weather;          // 天气指数
@property (nonatomic, copy)NSString *week;             // 星期
@property (nonatomic, copy)NSString *wind;             // 风向

@end
