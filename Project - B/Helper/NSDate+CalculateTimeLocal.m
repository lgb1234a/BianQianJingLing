//
//  NSDate+CalculateTimeLocal.m
//  Project - B
//
//  Created by lcy on 15/10/29.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "NSDate+CalculateTimeLocal.h"

@implementation NSDate (CalculateTimeLocal)

+ (NSString *)getCurrentDateStr:(NSString *)dateStr
{
    NSDateFormatter *littleFromatter = [[NSDateFormatter alloc] init];
    [littleFromatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate *senddate=[littleFromatter dateFromString:dateStr];
    senddate = [NSDate getNowDateFromatAnDate:senddate];
    return [littleFromatter stringFromDate:senddate];
}


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    return destinationDateNow;
}


@end
