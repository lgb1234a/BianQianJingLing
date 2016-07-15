//
//  DDTransformation.h
//  Project - B
//
//  Created by 王渊博 on 15/10/29.
//  Copyright © 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDTransformation : NSObject

//字典转data
+ (NSData*)returnDataWithDictionary:(NSDictionary*)dict;

//路径文件转dictonary
+ (NSDictionary*)returnDictionaryWithData:(NSData *)data;

@end
