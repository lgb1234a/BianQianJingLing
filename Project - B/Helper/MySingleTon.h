//
//  MySingleTon.h
//  Project - B
//
//  Created by lcy on 15/10/17.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MySingleTon : NSObject

// 便条类型
@property (assign, nonatomic) NSInteger tipType;

// 是否处于编辑状态
@property (assign, nonatomic)BOOL isEditting;

// 本金
@property (assign, nonatomic) CGFloat principal;

// popin弹出视图是否保存
@property (assign, nonatomic)BOOL isSaveDown;

// 判断当前显示的视图控制器
@property (copy, nonatomic)NSString *VCOnDisplay;

// 存储当前点击的cell的title，用于对表进行操作的依据,cell的创建时间
@property (copy, nonatomic)NSString *cellTitle;

+ (instancetype)shareSingleTon;

@end
