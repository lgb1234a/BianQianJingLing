//
//  GuideView.m
//  引导页
//
//  Created by lcy on 15/11/3.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView


- (void)awakeFromNib
{
    
}


- (void)setGifData:(NSData *)gifData
{
    _gifData = [gifData copy];
    _imgView = [[SCGIFImageView alloc] initWithGIFData:gifData];
}

@end
