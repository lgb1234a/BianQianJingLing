//
//  SPNavigationController.m
//  SPNavigationController
//
//  Created by Leroy on 7/22/14.
//  Copyright (c) 2014 Leroy. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "SPNavigationController.h"
#import "FRDLivelyButton.h"
#import "MySingleTon.h"
#define SCWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCHEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface SPNavigationController ()
{
    kFRDLivelyButtonStyle newStyle;
    FRDLivelyButton *button;
    
    NSMutableArray *_tagArray;
    NSMutableArray *_centerArray;
}

@property (nonatomic, strong)NSArray *VCArr;  // VC名字的数组

@end

@implementation SPNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tagArray = [[NSMutableArray alloc] initWithArray:@[@100, @101, @102, @103,@104, @105]];
        _VCArr = @[@"rootVC", weatherTableName, noteTableName, notificationTableName, accountTableName, restDayTableName];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatCenterPointAndTag];
    [self addViewToMainView];
    [self setFrdButton];
    
}

- (void)addViewToMainView
{
    for (NSInteger i = self.viewControllers.count - 1 ; i >= 0; i --) {
        UIViewController *temp = self.viewControllers[i];
        temp.view.tag = [_tagArray[i] intValue];
        [self.view addSubview:temp.view];
        [self setViewController:temp];
    }

}

-(void)creatCenterPointAndTag
{
    NSInteger viewCount = self.viewControllers.count;
    _centerArray = [[NSMutableArray alloc]init];
    for (NSInteger i = viewCount -1; i >= 0; i --) {
        NSValue *pointValue =  [NSValue valueWithCGPoint:CGPointMake(85 + (viewCount/2 - i) * (40 * 7 / viewCount), SCHEIGHT / 2 + (viewCount/2 - i) * 40 * 4 / viewCount)];
        [_centerArray addObject:pointValue];
    }
    _tagArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < viewCount; i ++) {
        [_tagArray addObject:@(i + 100)];
    }

}

#pragma mark SetViewController ------------------------------
-(void)setViewController:(UIViewController*)tempVc
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(selectView:)];
    pan.enabled = NO;
    [tempVc.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectViewTap:)];
    tap.enabled = NO;
    [tempVc.view addGestureRecognizer:tap];
    
    tempVc.view.layer.shadowOffset = CGSizeMake(2, 2);
    tempVc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    tempVc.view.layer.shadowOpacity = YES;

}

#pragma mark  FRDLivelyButton --------------------------------
-(void)setFrdButton
{
    button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(15,SCHEIGHT - 35,30,20)];
    
    [button setOptions:@{ kFRDLivelyButtonLineWidth: @(3.0f),
                          kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                          kFRDLivelyButtonColor: [UIColor colorWithRed:0.841 green:0.632 blue:0.391 alpha:1.000]
                          }];
    [button setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(FRDLivelyButton *)sender
{
    if (sender.buttonStyle == 0) {
        newStyle = 1;
        [sender setStyle:newStyle animated:YES];
        [self changeCenter:_centerArray tag:_tagArray];
        
    }else{
        newStyle = 0;
        [self backFrame];
        [sender setStyle:newStyle animated:YES];
    }
}

#pragma mark changeView Center
-(void)changeCenter:(NSArray *) centerArray tag:(NSArray*)tagArray
{
    
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i < [centerArray count]; i ++) {
            UIView *temp = [self.view viewWithTag:[tagArray[i] integerValue]];
            
            temp.center = [centerArray[i] CGPointValue];
            temp.transform = CGAffineTransformMakeScale(0.7, 0.7);
            
            for (UIGestureRecognizer *gesTemp in temp.gestureRecognizers) {
                gesTemp.enabled = YES;
            }

        }
    }];
}

//  还原所有视图的frame

-(void)backFrame
{
    
    if (button.buttonStyle == 0) {
        return;
    }
    
    [button setStyle:0 animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *temp in self.view.subviews) {
            
            if ([temp.nextResponder isKindOfClass:[UIViewController class]]) {
                temp.center = CGPointMake(SCWIDTH / 2, SCHEIGHT / 2);
                temp.transform = CGAffineTransformMakeScale(1, 1);
                
                for (UIGestureRecognizer *gesTemp in temp.gestureRecognizers) {
                    gesTemp.enabled = NO;
                }

            }
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.view bringSubviewToFront:button];
    
}

//  选取View 放大到主页
-(void)selectView:(UIPanGestureRecognizer *)pan
{
    
    if (button.buttonStyle == 0) {
        return;
    }
    
    UIView *temp = pan.view;
    CGPoint point = [[_centerArray objectAtIndex:[_tagArray indexOfObject:@(temp.tag)]] CGPointValue];
    
    [self.view bringSubviewToFront:temp];
    
    CGPoint translation = [pan translationInView:temp];
    
    float x = temp.center.x + translation.x;
    
    if (x >= self.view.center.x) {
        x = self.view.center.x;
    }
    
    if (x <= point.x) {
        x = point.x;
    }
    temp.center = CGPointMake(x, temp.center.y);
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (temp.center.x >= self.view.center.x - 10) {
            
            [_tagArray removeObject:@(temp.tag)];
            [_tagArray insertObject:@(temp.tag) atIndex:0];
            
            [self backFrame];
            
        }else{
            
            [UIView animateWithDuration:0.3 animations:^{
                temp.center = CGPointMake(point.x, temp.center.y);
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    [self resumeCenter:_centerArray tag:_tagArray];
                }
                
            }];
        }
    }
    
    [pan setTranslation:CGPointZero inView:temp];
    
    [self.view bringSubviewToFront:button];
    
}

-(void)selectViewTap:(UITapGestureRecognizer*)tap
{
    UIView *temp = tap.view;
    NSLog(@"%@", tap.view);
    
    [MySingleTon shareSingleTon].VCOnDisplay = _VCArr[tap.view.tag - 100];
    
    [self.view bringSubviewToFront:temp];
    
    [_tagArray removeObject:@(temp.tag)];
    [_tagArray insertObject:@(temp.tag) atIndex:0];
    
    [self backFrame];
    [self.view bringSubviewToFront:button];
    
    
}

//  还原所有视图到原始位置

-(void)resumeCenter:(NSArray *) Center tag:(NSArray*)tagArray
{
    [UIView beginAnimations:nil context:NULL];
    
    for (int i = (int)[Center count] -1 ; i >= 0 ; i --) {
        UIView *temp = [self.view viewWithTag:[tagArray[i] integerValue]];
        [self.view addSubview:temp];
    }
    
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
