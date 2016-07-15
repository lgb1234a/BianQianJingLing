//
//  PKDataBaseManage.h
//  Project-A
//
//  Created by lcy on 15/9/27.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

typedef NS_ENUM(NSUInteger, dataBaseManageType) {
    dataBaseManageTypeStoreData,
    dataBaseManageTypeQueryData,
    dataBaseManageTypeQueryAllData,
    dataBaseManageTypeDeleteData,
    dataBaseManageTypeDeleteAllData
};

typedef void(^getDataFromDict)(NSData *data);

@interface PKDataBaseManage : NSObject

+ (void)DBManage:(NSData *)data tableName:(NSString *)tableName dataName:(NSString *)dataName manageType:(dataBaseManageType)type getDataFromDict:(getDataFromDict)getDataBlock;


+ (void)dataDeleteFromDB:(FMDatabase *)db tableName:(NSString *)tableName dataName:(NSString *)dataName;

+ (void)allDataDeleteFromDB:(FMDatabase *)db tableName:(NSString *)tableName;

+ (void)dataStoreIntoDB:(FMDatabase *)db tableName:(NSString *)tableName data:(NSData *)data dataName:(NSString *)dataName;

+ (void)dataQueryFromDB:(FMDatabase *)db tableName:(NSString *)tableName getDataFromDict:(getDataFromDict)getDataBlock dataName:(NSString *)dataName;

+ (void)allDataQueryFromDB:(FMDatabase *)db tableName:(NSString *)tableName getDataFromDict:(getDataFromDict)getDataBlock;

@end
