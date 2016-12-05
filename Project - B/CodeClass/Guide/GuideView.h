//
//  GuideView.h
//  引导页
//
//  Created by lcy on 15/11/3.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLImageView.h"
#import "YLGIFImage.h"
@interface GuideView : UIView

@property (weak, nonatomic) IBOutlet YLImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property (weak, nonatomic) IBOutlet UIButton *tapInBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *indexPageControl;

@property (copy, nonatomic) NSString *gifImage;


@end
