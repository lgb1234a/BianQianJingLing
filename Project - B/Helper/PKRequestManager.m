//
//  PKRequestManager.m
//  Project-A
//
//  Created by lcy on 15/9/26.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "PKRequestManager.h"

@implementation PKRequestManager

- (void)initWithType:(RequestType)type urlStr:(NSString *)urlStr parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)error
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 如果是post请求，需要设置参数和请求方式
    if(type == RequestTypePost)
    {
        // 设置请求方式
        [request setHTTPMethod:@"POST"];
        // 设置请求参数的body
        if(parDic.count > 0)
        {
           [request setHTTPBody:[self dataFromDictionary:parDic]];
        }
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data)
        {
            finish(data);
        }else
        {
            error(connectionError);
        }
    }];
}

+ (void)requestWithType:(RequestType)type urlStr:(NSString *)urlStr parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)error
{
    [[self alloc] initWithType:type urlStr:urlStr parDic:parDic finish:finish error:error];
}

// 把参数字典转为POST请求所需要的参数体
- (NSData *)dataFromDictionary:(NSDictionary *)parDic
{
    NSMutableArray *array = [NSMutableArray array];
    // 遍历字典的每一个键，得到所有的key ＝ value格式的字符串
    for (NSString *key in parDic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, parDic[key]];
        [array addObject:str];
    }
    NSString *str = [array componentsJoinedByString:@"&"];
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

@end
