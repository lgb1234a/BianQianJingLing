//
//  GuideView.h
//  引导页
//
//  Created by lcy on 15/11/3.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGIFImageView.h"
@interface GuideView : UIView

@property (strong, nonatomic) IBOutlet SCGIFImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property (weak, nonatomic) IBOutlet UIButton *tapInBtn;

@property (strong, nonatomic) NSData *gifData;


@end
