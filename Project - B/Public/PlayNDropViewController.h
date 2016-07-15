//
//  PlayNDropViewController.h
//  CCMPlayNDropViewSample
//
//  Created by Compean on 29/11/14.
//  Copyright (c) 2014 Carlos Compean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMPlayNDropView.h"

typedef void(^dismissLabelBlock)();

@interface PlayNDropViewController : UIViewController <CCMPlayNDropViewDelegate>

//@property UIViewController *presentingController;
@property (nonatomic, strong)NSMutableArray *tipArr;  // 时间轴上面的便签数

@property (nonatomic, copy)dismissLabelBlock block;  // 提示的Label消失

@end
