//
//  BoarderTest.h
//  Project - B
//
//  Created by lcy on 15/11/3.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "customBtn.h"
/**
 *  传入数组，以及当前移动的btn，判断btn与任意相近的两个btn是否有边界接触，如果有，则无法继续移动，返回NO
 */
@interface BoarderTest : NSObject

- (BOOL)isBtnBoardInteractInBtnArr:(NSArray *)btnArr withBtn:(customBtn *)btn;

@end
