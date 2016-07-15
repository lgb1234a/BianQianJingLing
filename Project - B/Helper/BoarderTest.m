//
//  BoarderTest.m
//  Project - B
//
//  Created by lcy on 15/11/3.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "BoarderTest.h"

@implementation BoarderTest

- (BOOL)isBtnBoardInteractInBtnArr:(NSArray *)btnArr withBtn:(customBtn *)btn
{
    BOOL isIntersects;
    for(customBtn *customBtn in btnArr)
    {
        isIntersects = CGRectIntersectsRect(customBtn.frame, btn.frame);
        if(isIntersects)
        {
            return YES;
        }
    }
    return NO;
}

@end
