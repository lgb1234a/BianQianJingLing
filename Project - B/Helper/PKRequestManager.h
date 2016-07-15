//
//  PKRequestManager.h
//  Project-A
//
//  Created by lcy on 15/9/26.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType)
{
    RequestTypePost,
    RequestTypeGet
};

// 网络请求完成的block
typedef void(^RequestFinish)(NSData *data);
// 网络请求失败的block
typedef void(^RequestError)(NSError *error);

@interface PKRequestManager : NSObject
// 外界会调用这个方法，传递过来我们请求的时候所需要的参数，同时把请求完成后相应的处理也传给这个类，方便这个类请求之后把相应的结果回传给外界。
//- (void)initWithType:(RequestType *)type urlStr:(NSString *)urlStr parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)error;

+ (void)requestWithType:(RequestType)type urlStr:(NSString *)urlStr parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)error;

@end
