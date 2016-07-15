//
//  PKDataBaseManage.m
//  Project-A
//
//  Created by lcy on 15/9/27.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "PKDataBaseManage.h"
@implementation PKDataBaseManage

// 数据库操作
+ (void)DBManage:(NSData *)data tableName:(NSString *)tableName dataName:(NSString *)dataName manageType:(dataBaseManageType)type getDataFromDict:(getDataFromDict)getDataBlock
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"user.sqlite"];

//    NSLog(@"%@", dbpath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    if([db open])
    {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (dataName text primary key, jsonData blob)", tableName];
        BOOL rs = [db executeUpdate:sql];
        if(!rs)
        {
            NSLog(@"建表失败");
        }else
        {
            NSLog(@"建表成功");
            if(type == dataBaseManageTypeStoreData) //存储数据
            {
                [self dataStoreIntoDB:db tableName:tableName data:data dataName:dataName];
            }else if(type == dataBaseManageTypeQueryData) // 查询数据
            {
                [self dataQueryFromDB:db tableName:tableName getDataFromDict:getDataBlock dataName:dataName];
            }else if (type ==  dataBaseManageTypeQueryAllData) // 查询整表
            {
                [self allDataQueryFromDB:db tableName:tableName getDataFromDict:getDataBlock];
            }
            else if (type ==  dataBaseManageTypeDeleteAllData) // 删除整表数据
            {
                [self allDataDeleteFromDB:db tableName:tableName];
            }
            else // 删除数据
            {
                [self dataDeleteFromDB:db tableName:tableName dataName:dataName];
            }
        }
    }
}

// 删除数据
+ (void)dataDeleteFromDB:(FMDatabase *)db tableName:(NSString *)tableName dataName:(NSString *)dataName
{
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where dataName = ?", tableName];
    BOOL rs = [db executeUpdate:deleteSql, dataName];
    
    if(!rs)
    {
        NSLog(@"删除失败");
    }else
    {
        NSLog(@"删除成功");
    }
}

// 删除整表数据
+ (void)allDataDeleteFromDB:(FMDatabase *)db tableName:(NSString *)tableName
{
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@", tableName];
    BOOL rs = [db executeUpdate:deleteSql];
    
    if(!rs)
    {
        NSLog(@"删除整表数据失败");
    }else
    {
        NSLog(@"删除整表数据");
    }
}

// 数据库存储数据
+ (void)dataStoreIntoDB:(FMDatabase *)db tableName:(NSString *)tableName data:(NSData *)data dataName:(NSString *)dataName
{
    // 存储数据只需要删除weather的表
    if([tableName isEqualToString:weatherTableName])
    {
        [self allDataDeleteFromDB:db tableName:weatherTableName];
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (dataName, jsonData) values (?, ?)", tableName];
    BOOL res = [db executeUpdate:sql, dataName, data];
    if(!res)
    {
        NSLog(@"插入数据失败");
    }else
    {
        NSLog(@"插入数据成功");
    }
    [db close];
}

// 数据库查询数据
+ (void)dataQueryFromDB:(FMDatabase *)db tableName:(NSString *)tableName getDataFromDict:(getDataFromDict)getDataBlock dataName:(NSString *)dataName
{
    NSString *sql = [NSString stringWithFormat:@"select jsonData from %@ where dataName = ?", tableName];
    FMResultSet * rs = [db executeQuery:sql, dataName];
    
    while ([rs next])
    {
        NSData *jsonData = [rs dataForColumnIndex:0];
        getDataBlock(jsonData);
    }
    [db close];
}

// 数据库查询整表数据
+ (void)allDataQueryFromDB:(FMDatabase *)db tableName:(NSString *)tableName getDataFromDict:(getDataFromDict)getDataBlock
{
    NSString *sql = [NSString stringWithFormat:@"select jsonData from %@", tableName];
    FMResultSet * rs = [db executeQuery:sql];
    
    while ([rs next])
    {
        NSData *jsonData = [rs dataForColumnIndex:0];
        getDataBlock(jsonData);
    }
    [db close];
}

@end
