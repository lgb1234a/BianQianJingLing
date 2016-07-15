//
//  MySingleTon.m
//  Project - B
//
//  Created by lcy on 15/10/17.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "MySingleTon.h"

@implementation MySingleTon

+ (instancetype)shareSingleTon
{
    static MySingleTon *singleTon = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        singleTon = [[MySingleTon alloc] init];
    });
    return singleTon;
}


@end
