//
//  CustomPlayerView.m
//  DouyuProject
//
//  Created by 王渊博 on 15/11/3.
//  Copyright © 2015年 浮云千载唯忆君颜. All rights reserved.
//

#import "CustomPlayerView.h"

@implementation CustomPlayerView
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)thePlayer
{
    return [(AVPlayerLayer*)[self layer]setPlayer:thePlayer];
}

@end
