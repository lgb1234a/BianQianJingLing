//
//  DDTransformation.m
//  Project - B
//
//  Created by 王渊博 on 15/10/29.
//  Copyright © 2015年 lcy. All rights reserved.
//

#import "DDTransformation.h"

@implementation DDTransformation

//字典转data
+ (NSData*)returnDataWithDictionary:(NSDictionary*)dict
{
    
//    NSError *parseError = nil;
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
//    
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];
    return data;
}

//路径文件转dictonary
+ (NSDictionary*)returnDictionaryWithData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    return myDictionary;
}


@end
