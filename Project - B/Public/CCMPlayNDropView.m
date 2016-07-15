//
//  SwarmStyleDismissableView.m
//  SwarmLikeDismissable

//  Copyright 2014 Carlos Compean

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Created by Carlos Compean on 12/11/14.
//

#import "CCMPlayNDropView.h"
#import "UIColor+ThemeColor.h"
#import "MySingleTon.h"
#import "PlayNDropViewController.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#define DEFAULT_RADIUS 25

@interface CCMPlayNDropView() <CLLocationManagerDelegate>

@property CGPoint oldPosition;
@property UIDynamicAnimator *animator;
@property UIDynamicAnimator *oldAnimator;
@property (weak) UIDynamicItemBehavior *itemBehavior;
@property (weak) UIAttachmentBehavior *attachment;
@property (weak) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic)UILabel *timeLabel;            // 时间

@property (nonatomic, strong)CLLocationManager *locationManager; // 定位
//@property (nonatomic, strong)UIWebView *weatherView;        // 天气展示
//@property CGRect nonDismissingFrame;

@end

@implementation CCMPlayNDropView

@synthesize gravity = _gravity;
@synthesize maxAngle = _maxAngle;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialSetup];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
        switch ([MySingleTon shareSingleTon].tipType) {
            case 1:  // 天气
            {
                [self initTimaLabel];
                self.weatherView = [[WeatherTipView alloc] initWithFrame:CGRectMake(20, 60, 260, 320)];
                
                [self addSubview:self.weatherView];
                
                // 自动定位
                [self locate];
                
            }
                break;
                
                case 2: // 提醒
            {
                [self initTimaLabel];
                _notificationView = [[NotificationTipView alloc] initWithFrame:CGRectMake(20, 60, 260, 320)];
                [self addSubview:_notificationView];
                
            }
                break;
                case 3:  // 笔记
            {
                self.noteView = [[NoteTipView alloc] initWithFrame:CGRectMake(20, 60, 260, 320)];
                [self addSubview:self.noteView];
                // 添加时间
                [self initTimaLabel];
            }
                break;
                case 4:  // 账本
            {
                [self initTimaLabel];
                self.accountView = [[AccountTipView alloc] initWithFrame:CGRectMake(20, 60, 260, 320)];
                [self addSubview:self.accountView];
            }
                break;
                case 5: // 倒数日
            {
                [self initTimaLabel];
                self.restDayTipView = [[RestdayTipView alloc] initWithFrame:CGRectMake(20, 60, 260, 320)];
                [self addSubview:self.restDayTipView];
            }
                break;
            default:
                break;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTheFirstResponder:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

// 定位当前城市
- (void)locate
{
    // 判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        [_locationManager requestAlwaysAuthorization];//添加这句
        
        self.locationManager.delegate = self;
        
    }else {
        
        //提示用户无法进行定位操作
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  
                                  @"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
        
    }
    
    // 开始定位
    
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     
     {
         
         if (array.count > 0)
             
         {
             
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //将获得的所有信息显示到label上
             
             NSLog(@"%@",placemark.name);
             
             //获取城市
             
             NSString *city = placemark.locality;
             
             if (!city) {
                 
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 
                 city = placemark.administrativeArea;
                 //                 NSLog(@"%@", city);
             }
             
             if([city hasSuffix:@"省"] || [city hasSuffix:@"市"])
             {
                 city = [city substringToIndex:city.length - 1];
             }else if ([city hasSuffix:@"自治区"])
             {
                 city = [city substringToIndex:city.length - 3];
             }
             
             self.weatherView.cityTextField.text = city;
             
         }
         
         else if (error == nil && [array count] == 0)
             
         {
             
             NSLog(@"No results were returned.");
             
         }
         
         else if (error != nil)
             
         {
             
             NSLog(@"An error occurred = %@", error);
             
         }
         
     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error
{
    
    NSLog(@"%@", error.userInfo);
    
}


// 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)resignTheFirstResponder:(UIGestureRecognizer *)recognizer
{
    [self endEditing:YES];
}

// 创建时间戳
- (void)initTimaLabel
{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 180, 30)];
    self.timeLabel.textColor = [UIColor colorWithTheme];
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd  HH:mm:ss"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    self.timeLabel.text = locationString;
    [self addSubview:self.timeLabel];
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initialSetup];
    }
    return  self;
}

-(void)initialSetup{
    //self.maxAngle = M_PI / 12.0;
    self.maxAngle = 15;
    self.gravity = 0.5;
    UIPanGestureRecognizer *panGesture =  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    _dismissable = YES;
    [self addGestureRecognizer:panGesture];
}

-(CGFloat)maxAngle{
    return _maxAngle;
}

-(void)setMaxAngle:(CGFloat)maxAngle{
    _maxAngle = maxAngle;
}

-(CGFloat)gravity{
    return _gravity;
}

-(void)setGravity:(CGFloat)gravity{
    _gravity = gravity;
}

- (void)dragging:(UIPanGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self draggingStarted:sender];
            break;
        case UIGestureRecognizerStateChanged:
            [self draggingMoved:sender];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            [self draggingEnded:sender];
            break;
        default:
            break;
    }
}

- (void)draggingStarted:(UIPanGestureRecognizer *)gesture{
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CCMPlayNDropViewManualTraslationDidStart:)]) {
        [self.delegate CCMPlayNDropViewManualTraslationDidStart:self];
    }
    
    if (self.locationReferenceView) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.locationReferenceView];
    } else {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    }
    
    //if (self.nonDismissingArea) {
//        CGSize size = [self.nonDismissingArea CGSizeValue];
//        self.nonDismissingFrame = CGRectMake(self.animator.referenceView.center.x - size.width/2.0, self.animator.referenceView.center.y - size.height/2.0, size.width, size.height);
//    } else {
//        self.nonDismissingFrame = CGRectMake(self.animator.referenceView.center.x - 50, self.animator.referenceView.center.y - 50, 100, 100);
//    }
    
//    CGRect nonDismissingFrame = CGRectMake(self.animator.referenceView.center.x - 50, self.animator.referenceView.center.y - 50, 100, 100);
//    UIView *nondismissingView = [[UIView alloc] initWithFrame:nonDismissingFrame];
//    nondismissingView.layer.cornerRadius = nonDismissingFrame.size.width / 2.0;
//    nondismissingView.clipsToBounds = YES;
//    nondismissingView.backgroundColor = [UIColor redColor];
//    [self.animator.referenceView addSubview:nondismissingView];
//    CGPoint centerGestureView = [self.animator.referenceView convertPoint:gesture.view.center toView:nondismissingView];
//    UIView *pixelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//    pixelView.center = centerGestureView;
//    pixelView.backgroundColor = [UIColor greenColor];
//    [nondismissingView addSubview:pixelView];
    //[self.animator.referenceView insertSubview:nondismissingView belowSubview:gesture.view];
    
    self.oldPosition = [gesture locationInView:self.animator.referenceView];
    //    if (!self.gravity) {
    //        //self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self.dynamicView]];
    //        //self.gravity.magnitude = 0.5;
    //        //[self.animator addBehavior:self.gravity];
    //    }
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[gesture.view]];
    self.itemBehavior = itemBehavior;
    itemBehavior.angularResistance = CGFLOAT_MAX;
    [self.animator addBehavior:itemBehavior];
    
    //UIGravityBehavior *gravity2 = [[UIGravityBehavior alloc] initWithItems:@[self.dynamicView]];
    //[gravity2 setAngle:3*M_PI_2];
    //[self.animator addBehavior:gravity2];
    CGPoint locationInView = [gesture locationInView:self.animator.referenceView];
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:gesture.view offsetFromCenter:UIOffsetMake(locationInView.x - gesture.view.center.x, locationInView.y - gesture.view.center.y) attachedToAnchor:[gesture locationInView:self.animator.referenceView]];
    self.attachment = attachment;
    //    self.attachment = [[UIAttachmentBehavior alloc] initWithItem:gesture.view attachedToAnchor:CGPointZero];
    [self.animator addBehavior:attachment];
}

- (CGFloat)percentageDismissableWithDissmissableRadius:(CGFloat)radius centerReference:(CGPoint)centerReference currentViewCenter:(CGPoint)viewCenter{
    CGFloat viewDistanceFromCenter = sqrt(pow(viewCenter.x - centerReference.x, 2.0)+pow(viewCenter.y - centerReference.y, 2.0));
    //CGFloat nonDismissingFrameDistanceFromCenter = sqrt(pow(nonDismissingFrameOrigin.x - centerReferenceView.x, 2.0)+pow(nonDismissingFrameOrigin.y - centerReferenceView.y, 2.0));
    CGFloat percentage = (viewDistanceFromCenter/radius > 1)? 1 : viewDistanceFromCenter/radius;
    return percentage;
}

- (CGFloat)angleBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2{
    CGFloat xDif = point2.x - point1.x;
    CGFloat yDif = point2.y - point1.y;
    yDif = -yDif;
    CGFloat angle = 0.0;
    if (yDif > 0) {
        angle = atan2(yDif, xDif) * (180/M_PI);
    } else if (yDif <= 0){
        angle = 360 + atan2(yDif, xDif) * (180/M_PI);
    }
    return angle;
}

- (void)draggingMoved:(UIPanGestureRecognizer *)gesture{
//    UIView *nondismissingView = self.animator.referenceView.subviews.lastObject;
//    UIView *pixelView = nondismissingView.subviews.firstObject;
//    pixelView.center = [self.animator.referenceView convertPoint:gesture.view.center toView:nondismissingView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CCMPlayNDropView:manualTraslationDidMoveWithPercentageToCancel:angle:)]) {
        CGFloat nonDismissableRadius = (self.nonDismissingRadius)? self.nonDismissingRadius.doubleValue : DEFAULT_RADIUS;
        CGFloat percentage = [self percentageDismissableWithDissmissableRadius:nonDismissableRadius centerReference:gesture.view.center currentViewCenter:self.animator.referenceView.center];
        CGFloat angle = [self angleBetweenPoint:self.animator.referenceView.center andPoint:[self.animator.referenceView.superview convertPoint:gesture.view.center fromView:self.animator.referenceView]];
        //        CGPoint nonDismissingFrameOrigin = self.nonDismissingFrame.origin;
        //        CGPoint centerReferenceView = self.animator.referenceView.center;
        //        CGFloat viewDistanceFromCenter = sqrt(pow(gesture.view.center.x - centerReferenceView.x, 2.0)+pow(gesture.view.center.y - centerReferenceView.y, 2.0));
        //        CGFloat nonDismissingFrameDistanceFromCenter = sqrt(pow(nonDismissingFrameOrigin.x - centerReferenceView.x, 2.0)+pow(nonDismissingFrameOrigin.y - centerReferenceView.y, 2.0));
        //        CGFloat percentage = (viewDistanceFromCenter/nonDismissingFrameDistanceFromCenter > 1)? 1 : viewDistanceFromCenter/nonDismissingFrameDistanceFromCenter;
        
        [self.delegate CCMPlayNDropView:self manualTraslationDidMoveWithPercentageToCancel:percentage angle:angle];
    }
    
    CGFloat rotation = atan2(gesture.view.transform.b, gesture.view.transform.a);
    //NSLog(@"rotation: %lf", rotation);
    CGFloat xDisplacement = [gesture locationInView:self.animator.referenceView].x - self.oldPosition.x;
    //CGFloat yDisplacement = [gesture locationInView:self.animator.referenceView].y - self.oldPosition.y;
    
    CGFloat maxAngleInRadians = self.maxAngle * M_PI / 180;
    CGFloat translationAngle = (maxAngleInRadians > 0)? maxAngleInRadians : -maxAngleInRadians;
    
    CGPoint gestureViewCenter = [self.animator.referenceView convertPoint:gesture.view.center toView:gesture.view];
    CGPoint touchLocationInGestureView = [gesture locationInView:gesture.view];
    //NSLog(@"current angle: %lf", atan2(gesture.view.transform.b, gesture.view.transform.a));
    if (touchLocationInGestureView.y > gestureViewCenter.y) {
        if (xDisplacement < 0 && rotation > translationAngle) {
            self.itemBehavior.allowsRotation = NO;
        } else if (xDisplacement > 0 && rotation < -translationAngle){
            self.itemBehavior.allowsRotation = NO;
        } else {
            self.itemBehavior.allowsRotation = YES;
        }
    } else {
        if (xDisplacement < 0 && rotation < -translationAngle) {
            self.itemBehavior.allowsRotation = NO;
        } else if (xDisplacement > 0 && rotation > translationAngle){
            self.itemBehavior.allowsRotation = NO;
        } else {
            self.itemBehavior.allowsRotation = YES;
        }
    }
    
    self.attachment.anchorPoint = [gesture locationInView:self.animator.referenceView];
    self.oldPosition = [gesture locationInView:self.animator.referenceView];
}

- (void)draggingEnded:(UIPanGestureRecognizer *)gesture{
    [self.animator removeBehavior:self.itemBehavior];
    [self.animator removeBehavior:self.attachment];
    
    CGFloat nonDismissableRadius = (self.nonDismissingRadius)? self.nonDismissingRadius.doubleValue : DEFAULT_RADIUS;
    CGFloat percentage = [self percentageDismissableWithDissmissableRadius:nonDismissableRadius centerReference:gesture.view.center currentViewCenter:self.animator.referenceView.center];
    
    if (self.dismissable && percentage == 1) { // view should be dismissed
    //if (self.dismissable && !CGRectContainsPoint(self.nonDismissingFrame, gesture.view.center)) { // view should be dismissed
        
        
        
        if (!self.gravityBehavior) {
            UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[gesture.view]];
            self.gravityBehavior = gravityBehavior;
            //if (self.gravity) {
                self.gravityBehavior.magnitude = self.gravity;
//            } else {
//                self.gravityBehavior.magnitude = 0.5;
//            }
            [self.animator addBehavior:self.gravityBehavior];
        }
        
        CGPoint v = [gesture velocityInView:self.animator.referenceView];
        CGFloat magnitude = sqrtf(powf(v.x, 2.0)+powf(v.y, 2.0));
        CGFloat angle = atan2(v.y, v.x);
        
        magnitude /= 45;
        
        CGPoint locationInView = [gesture locationInView:self.animator.referenceView];
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[gesture.view] mode:UIPushBehaviorModeInstantaneous];
        [pushBehavior setTargetOffsetFromCenter:UIOffsetMake(locationInView.x - gesture.view.center.x, locationInView.y - gesture.view.center.y) forItem:gesture.view];
        pushBehavior.magnitude = magnitude;
        pushBehavior.angle = angle;
        
        [self.animator addBehavior:pushBehavior];
        [self.animator removeBehavior:self.attachment];
        gesture.view.userInteractionEnabled = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(CCMPlayNDropViewWillStartDismissAnimationWithDynamics:)]) {
            [self.delegate CCMPlayNDropViewWillStartDismissAnimationWithDynamics:self];
        }
        [self performSelector:@selector(checkForFinishedDismissingView) withObject:nil afterDelay:0.1];
    } else { //view should be put back in it's original position
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(CCMPlayNDropViewCanceledDismissWithDynamics:)]) {
            [self.delegate CCMPlayNDropViewCanceledDismissWithDynamics:self];
        }
        
        UIView *view = self.animator.referenceView;
        self.animator = nil;
        
        CGFloat cancelDuration = 0.3;
        if (self.cancelAnimationDuration) {
            cancelDuration = self.cancelAnimationDuration.doubleValue;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(CCMPlayNDropView:willStartDismissCancelAnimationWithDuration:)]) {
            [self.delegate CCMPlayNDropView:self willStartDismissCancelAnimationWithDuration:cancelDuration];
        }
        [UIView animateWithDuration:cancelDuration animations:^{
            gesture.view.center = view.center;
            gesture.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(CCMPlayNDropViewDidFinishDismissCancelAnimation:)]) {
                [self.delegate CCMPlayNDropViewDidFinishDismissCancelAnimation:self];
            }
        }];
    }
    
}

-(void)checkForFinishedDismissingView{
    UIView *view = self.superview;
    if (self.locationReferenceView) {
        view = self.locationReferenceView;
    }
    if (!CGRectIntersectsRect(view.frame, [view.superview convertRect:self.frame fromView:view])) {
        self.animator = nil;
        self.userInteractionEnabled = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(CCMPlayNDropViewDidFinishDismissAnimationWithDynamics:)]) {
            [self.delegate CCMPlayNDropViewDidFinishDismissAnimationWithDynamics:self];
        }
        //[self removeFromSuperview];
    } else {
        [self performSelector:@selector(checkForFinishedDismissingView) withObject:nil afterDelay:0.1];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com