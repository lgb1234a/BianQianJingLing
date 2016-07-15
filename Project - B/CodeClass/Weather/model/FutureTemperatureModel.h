//
//  FutureTemperatureModel.h
//  Project - B
//
//  Created by lcy on 15/10/19.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FutureTemperatureModel : NSObject

@property (nonatomic, copy)NSString *date;  // 日期
@property (nonatomic, copy)NSString *temperature; // 温度
@property (nonatomic, copy)NSString *weather;  // 天气
@property (nonatomic, copy)NSString *week;    // 星期
@property (nonatomic, copy)NSString *wind;    // 风速

@end
