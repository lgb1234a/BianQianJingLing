//
//  CurrentWeatherModel.h
//  Project - B
//
//  Created by lcy on 15/10/19.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeatherModel : NSObject

@property (nonatomic, copy)NSString *humidity; // 污染指数
@property (nonatomic, copy)NSString *temp;     // 温度
@property (nonatomic, copy)NSString *time;     // 当前时间
@property (nonatomic, copy)NSString *wind_direction; // 当前风向
@property (nonatomic, copy)NSString *wind_strength;  // 当前风力

@end
