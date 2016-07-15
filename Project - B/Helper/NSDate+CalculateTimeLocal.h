//
//  NSDate+CalculateTimeLocal.h
//  Project - B
//
//  Created by lcy on 15/10/29.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalculateTimeLocal)


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

+ (NSString *)getCurrentDateStr:(NSString *)dateStr;

@end
