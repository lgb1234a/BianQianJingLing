//
//  ViewController.m
//  Project - B
//
//  Created by lcy on 15/10/15.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+ThemeColor.h"
#import "UIButton+Touch.h"
#import "customBtn.h"
#import <MaryPopin/UIViewController+MaryPopin.h>
#import "PlayNDropViewController.h"
#import "MySingleTon.h"
#import "PKDataBaseManage.h"
#import "DDTransformation.h"
#import "TGLStackedViewController.h"

@interface ViewController (){
//    CALayer *_layer;  // 落叶效果layer层
//    CALayer *_timeLayer; // 时间轴上的layer
}

@property (nonatomic, strong)UIButton *nailsBtn;        // 书钉按钮
@property (nonatomic, strong)UIView   *timeLine;        // 时间轴
@property (nonatomic, strong)customBtn *weatherBtn;      // 天气便条
@property (nonatomic, strong)customBtn *notificationBtn; // 提醒便条
@property (nonatomic, strong)customBtn *noteBtn;         // 笔记便条
@property (nonatomic, strong)customBtn *accBtn;          // 账户便条
@property (nonatomic, strong)customBtn *restdayBtn;     // 倒数日便条
@property (nonatomic, strong)NSMutableArray  *btnArray;        // 便条的数组
@property (nonatomic, strong)NSArray *shawodColorArr;   // 阴影颜色的数组
@property (nonatomic, strong)NSArray *backgroundArr;    // 背景颜色的数组
@property (nonatomic, strong)NSArray *titleArr;         // 标题数组
@property (nonatomic, strong)NSMutableArray *tipArr;     // 用于存放在时间轴上的标签
@property (nonatomic, strong)NSMutableArray *nailsTipArr;  // 书签钉下面的书签
@property (nonatomic, strong)CAKeyframeAnimation *frame;  // 抖动动画
@property (nonatomic, strong)UIButton *timeLineBtn;     // 时间轴btn
@property (nonatomic, strong)NSMutableArray *layerArr;  // 落叶array
@property (nonatomic, strong)NSMutableArray *originTipsArr;  // 启动程序时获取的tip
@property (nonatomic, strong)UILabel *infoLabel; // 提示View


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 主题色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自定义图层
    CALayer *layer = [[CALayer alloc]init];
    layer.anchorPoint = CGPointMake(0, 1);
    layer.bounds = CGRectMake(0, 0, 320, 480);
    layer.position = CGPointMake(0, KScreen_Height);
    //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
    //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
    layer.masksToBounds = YES;
    //设置图层代理
    layer.delegate = self;
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
    
    // 时间针
    _timeLineBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreen_Width * 13 / 15.0 + 1 - 16, KScreen_Height * 0.2 - 16, 32, 32)];
    [_timeLineBtn setBackgroundImage:[UIImage imageNamed:@"时间针"] forState:UIControlStateNormal];
    _timeLineBtn.layer.anchorPoint = CGPointMake(0.5, 1);
    [self.view addSubview:_timeLineBtn];

    // 时间轴编辑（长按实现）
    // 时间轴
    _timeLine = [[UIView alloc] initWithFrame:CGRectMake(KScreen_Width * 13 / 15.0, KScreen_Height * 0.2, 3, KScreen_Height * 0.7)];
    _timeLine.backgroundColor = [UIColor colorWIthTimeLine];
    [self.view addSubview:_timeLine];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.allowableMovement = 30;
    [_timeLineBtn addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTimeLineBtn:)];
    [_timeLineBtn addGestureRecognizer:tapGesture];
    
    
    // 书钉按钮
    _nailsBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreen_Width / 15.0, KScreen_Height * 0.1, KScreen_Height * 0.1, KScreen_Height * 0.1)];
    [_nailsBtn setCornerRadius:KScreen_Height * 0.05];
    [_nailsBtn setBackgroundColor:[UIColor colorWithBookNails]];
    [_nailsBtn setShadowOffset];
    [_nailsBtn setShadowOpacity];
    [_nailsBtn setShadowColor:[UIColor bookNailsShadowColor]];
    
    [_nailsBtn addTarget:self action:@selector(didClickNailsToCreateTips:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nailsBtn];
    
    
    
    // 天气，提醒，笔记，账本,倒数日
    
    CGFloat tipX = tipsX;
    CGFloat tipY = tipsY;
    CGFloat tipW = finalW;
    CGFloat tipH = tipsH;
    
    // 便签属性
    _shawodColorArr = @[[UIColor colorWithWeather], [UIColor colorWithNotification], [UIColor colorWithNote], [UIColor colorWithAccount], [UIColor colorWithRestDay]];
    _backgroundArr = @[[UIColor colorWithWeather], [UIColor colorWithNotification], [UIColor colorWithNote], [UIColor colorWithAccount], [UIColor colorWithRestDay]];
    _titleArr = @[@"天气", @"提醒", @"笔记", @"收支", @"倒数日"];
    
    // 创建
    for(int i = 0; i < 5; i ++)
    {
        customBtn *tip = [self createTipsWithFrame:CGRectMake(tipX, tipY, 0, tipH) finalRect:CGRectMake(tipX, tipY, tipW, tipH) tag:(i + 1) isOrigin:NO];
        [self.btnArray addObject:tip];
        [self.nailsTipArr addObject:tip];
    }
    
    // 初始化时间轴上的tip
    [self initTipsOnTimeLine];
    
    // 接收删除消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteCell:) name:@"restDayDeleteCell" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteCell:) name:@"notificationDeleteCell" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteCell:) name:@"noteDeleteCell" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteCell:) name:@"accountDeleteCell" object:nil];
    
    // 创建的时候，给btn绑定
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateCell:) name:@"restDay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateCell:) name:@"notification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateCell:) name:@"note" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateCell:) name:@"account" object:nil];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreen_Width, (KScreen_Height - 200) * 0.5, 20, 200)];
    self.infoLabel.hidden = YES;
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = @"向右拖拽即可存储!";
    self.infoLabel.textColor = [UIColor redColor];
    self.infoLabel.backgroundColor = [UIColor colorWithRed:0.918 green:1.000 blue:0.902 alpha:0.800];
    [self.view addSubview:self.infoLabel];
    
}

- (NSMutableArray *)btnArray
{
    if(_btnArray == nil)
    {
        self.btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableArray *)tipArr
{
    if(_tipArr == nil)
    {
        self.tipArr = [NSMutableArray array];
    }
    return _tipArr;
}

- (NSMutableArray *)nailsTipArr
{
    if(_nailsTipArr == nil)
    {
        self.nailsTipArr = [NSMutableArray array];
    }
    return _nailsTipArr;
}

- (NSMutableArray *)layerArr
{
    if(_layerArr == nil)
    {
        self.layerArr = [NSMutableArray array];
    }
    return _layerArr;
}

- (NSMutableArray *)originTipsArr
{
    if(_originTipsArr == nil)
    {
        self.originTipsArr = [NSMutableArray array];
    }
    return _originTipsArr;
}

// 创建tip
- (customBtn *)createTipsWithFrame:(CGRect)rect finalRect:(CGRect)finalRect tag:(NSInteger)tag isOrigin:(BOOL)isOrigin
{
    // 防止block的循环引用
    CGRect timeLineFrame = _timeLine.frame;
    __block ViewController *VC = self;
    UIButton *btn = _nailsBtn;
    
    customBtn *tips = [[customBtn alloc] initWithFrame:rect];
    tips.isOnLine = isOrigin;

    [tips setBackgroundColor:_backgroundArr[tag - 1]];
    tips.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [tips setTitle:_titleArr[tag - 1] forState:UIControlStateNormal];
    [tips setShadowOffset];
    [tips setShadowOpacity];
    [tips setShadowColor:[_shawodColorArr[tag - 1] CGColor]];
    
    [self.view addSubview:tips];
    
    __weak customBtn *custombtn = tips;
    custombtn.tag = tag;
    
    // 移动过程中的判定
    tips.moveBlock = ^(CGPoint center, customBtn *touchBtn)
    {
        
        if(!CGRectIntersectsRect(touchBtn.frame, timeLineFrame) && !touchBtn.isOnLine)
        {
            _timeLine.backgroundColor = [UIColor redColor];
            
        }else
        {
            if([MySingleTon shareSingleTon].isEditting)
            {
                _timeLine.backgroundColor = [UIColor redColor];
            }else
            {
                _timeLine.backgroundColor = [UIColor colorWIthTimeLine];
            }
        }
    };
    
    // 移动结束
    tips.block = ^(CGPoint center, customBtn *touchBtn)
    {
//        [_animator removeAllBehaviors];
        // 处于编辑状态，高亮显示
        if([MySingleTon shareSingleTon].isEditting)
        {
            _timeLine.backgroundColor = [UIColor redColor];
        }else
        {
            _timeLine.backgroundColor = [UIColor colorWIthTimeLine];
        }
        
        // 移除书签钉的标签
        [self.nailsTipArr removeObject:touchBtn];
        // 便条在时间轴上
        if(CGRectIntersectsRect(touchBtn.frame, timeLineFrame))
        {
            
            // 不在时间轴上的标签移动到时间轴上才需要创建标签编辑框
            if(!touchBtn.isOnLine)
            {
                // 移除书签钉的标签
//                [self.nailsTipArr removeObject:touchBtn];
                
                // 标签创建后，加入到标签数组中，点击编辑按钮后，时间轴和轴上的标签抖动，处于可自由移动状态
                [self.tipArr addObject:touchBtn];
                
                // 弹出标签编辑
                [VC pressedShowCCMPlayNDropView:touchBtn];
                
                if([MySingleTon shareSingleTon].isEditting)
                {
                    [touchBtn.layer addAnimation:_frame forKey:@"transform.rotation"];
                }
            }
        }else  // 纸片飘落
        {
            // 如果标签在时间轴上并且处于编辑状态被移除，去除抖动效果
            if(touchBtn.isOnLine && [MySingleTon shareSingleTon].isEditting)
            {
                [touchBtn.layer removeAnimationForKey:@"transform.rotation"];
                
                // 删除数据库对应的便签
                [MySingleTon shareSingleTon].cellTitle = touchBtn.buildDate;
                switch (touchBtn.tag) {
                    
                    case 2: // @"提醒"
                        [PKDataBaseManage DBManage:nil tableName:notificationTableName dataName:[MySingleTon shareSingleTon].cellTitle manageType:dataBaseManageTypeDeleteData getDataFromDict:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDeleteCell" object:self];
                        break;
                    case 3: //  @"笔记"
                        [PKDataBaseManage DBManage:nil tableName:noteTableName dataName:[MySingleTon shareSingleTon].cellTitle manageType:dataBaseManageTypeDeleteData getDataFromDict:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"noteDeleteCell" object:self];
                        break;
                    case 4:  // @"账本"
                        [PKDataBaseManage DBManage:nil tableName:accountTableName dataName:[MySingleTon shareSingleTon].cellTitle manageType:dataBaseManageTypeDeleteData getDataFromDict:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"accountDeleteCell" object:self];
                        break;
                    case 5:  // @"倒数日"
                        [PKDataBaseManage DBManage:nil tableName:restDayTableName dataName:[MySingleTon shareSingleTon].cellTitle manageType:dataBaseManageTypeDeleteData getDataFromDict:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"restDayDeleteCell" object:self];
                        break;
                        
                    default:
                        break;
                }
            }
            
            // 滑落
            [self.layerArr addObject:touchBtn.layer];
            
            // 创建动画
            [VC translationAnimation:center withLayer:touchBtn.layer withIndex:self.layerArr.count - 1];
            [VC rotationAnimation:touchBtn.layer];
            
        }
        
        // 仅在时间轴上移动不生成新标签
        if(self.nailsTipArr.count < 5)
        {
            // 生成新的便签
            customBtn *tip = [[customBtn alloc] initWithFrame:rect];
            
            [self.nailsTipArr addObject:tip];
            tip.tag = custombtn.tag;
            tip.block = custombtn.block;
            tip.moveBlock = custombtn.moveBlock;
            [tip setBackgroundColor:_backgroundArr[tag - 1]];
            tip.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [tip setTitle:_titleArr[tag - 1] forState:UIControlStateNormal];
            
            [tip setShadowOffset];
            [tip setShadowOpacity];
            [tip setShadowColor:[_shawodColorArr[tag - 1] CGColor]];
            // 视图层次
            [VC.view addSubview:tip];
            [VC.view insertSubview:tip belowSubview:btn];
            
            [UIView animateWithDuration:5.0 animations:^{
                
                // 设置锚点，frame
                tip.layer.anchorPoint = CGPointMake(0, 0.5);
                tip.frame = finalRect;
                
                // 旋转动画
                tip.transform = CGAffineTransformMakeRotation((tag - 3) * M_PI / 8.0);
            }];
        }
    };
    return tips;
}

// 创建cell，让时间轴上的tip绑定一个创建时间，在删除对应标签的时候，让前后一块删除
- (void)didCreateCell:(NSNotification *)notification
{
    customBtn *btn = [self.tipArr lastObject];
    
    btn.buildDate = notification.userInfo[@"buildTime"];
}

// 删除时间轴上对应tip
- (void)didDeleteCell:(NSNotification *)notification
{
    // 不接收来自当前VC的删除cell的通知
    if(notification.object != self)
    {
        for(customBtn *btn in self.tipArr)
        {
            // 如果时间匹配
            if([[MySingleTon shareSingleTon].cellTitle isEqualToString:btn.buildDate])
            {
                [self.tipArr removeObject:btn];
                [btn removeFromSuperview];
                return;
            }
        }
    }
}

// 启动程序时，在主界面上显示的标签

- (void)initTipsOnTimeLine
{
    // @"天气", @"提醒", @"笔记", @"账本", @"倒数日"
    
    // 天气
    [PKDataBaseManage DBManage:nil tableName:weatherTableName dataName:@"weather" manageType:dataBaseManageTypeQueryData getDataFromDict:^(NSData *data) {
        
        if(data != nil)
        {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            
            // 创建天气tip
            [self.originTipsArr addObject:dic];
            
            customBtn *btn = [self createTipsWithFrame:CGRectMake(KScreen_Width * 13 / 15.0 - finalW * 0.5 - 10, KScreen_Height * 0.2 + 40 + (self.originTipsArr.count - 1) * (tipsH + 10), finalW, tipsH) finalRect:CGRectMake(tipsX, tipsY, finalW, tipsH) tag:1 isOrigin:YES];
            
            [self.tipArr addObject:btn];
        }
        
        
    }];
    
    // 提醒
    [PKDataBaseManage DBManage:nil tableName:notificationTableName dataName:nil manageType:dataBaseManageTypeQueryAllData getDataFromDict:^(NSData *data) {
        
        // 初始化
        NSDictionary *dic = [DDTransformation returnDictionaryWithData:data];
        
        [self.originTipsArr addObject:dic];
        
        customBtn *btn = [self createTipsWithFrame:CGRectMake(KScreen_Width * 13 / 15.0 - finalW * 0.5 - 10, KScreen_Height * 0.2 + 40 + (self.originTipsArr.count - 1) * (tipsH + 10), finalW, tipsH) finalRect:CGRectMake(tipsX, tipsY, finalW, tipsH) tag:2 isOrigin:YES];
        
        btn.buildDate = dic[@"buildTime"];
        
        [self.tipArr addObject:btn];
        
    }];
    
    // 笔记
    [PKDataBaseManage DBManage:nil tableName:noteTableName dataName:nil manageType:dataBaseManageTypeQueryAllData getDataFromDict:^(NSData *data) {
        // 初始化
        NSDictionary *dic = [DDTransformation returnDictionaryWithData:data];
        
        [self.originTipsArr addObject:dic];
        
        customBtn *btn = [self createTipsWithFrame:CGRectMake(KScreen_Width * 13 / 15.0 - finalW * 0.5 - 10, KScreen_Height * 0.2 + 40 + (self.originTipsArr.count - 1) * (tipsH + 10), finalW, tipsH) finalRect:CGRectMake(tipsX, tipsY, finalW, tipsH) tag:3 isOrigin:YES];
        
        btn.buildDate = dic[@"buildTime"];
        
        [self.tipArr addObject:btn];
        
    }];
    
    // 账本
    [PKDataBaseManage DBManage:nil tableName:accountTableName dataName:nil manageType:dataBaseManageTypeQueryAllData getDataFromDict:^(NSData *data) {
        // 初始化
        NSDictionary *dic = [DDTransformation returnDictionaryWithData:data];
        
        [self.originTipsArr addObject:dic];
        
        // 创建
        customBtn *btn = [self createTipsWithFrame:CGRectMake(KScreen_Width * 13 / 15.0 - finalW * 0.5 - 10, KScreen_Height * 0.2 + 40 + (self.originTipsArr.count - 1) * (tipsH + 10), finalW, tipsH) finalRect:CGRectMake(tipsX, tipsY, finalW, tipsH) tag:4 isOrigin:YES];
        
        btn.buildDate = dic[@"buildTime"];
        
        [self.tipArr addObject:btn];
    }];
    
    
    
    // 剩余日
    [PKDataBaseManage DBManage:nil tableName:restDayTableName dataName:nil manageType:dataBaseManageTypeQueryAllData getDataFromDict:^(NSData *data) {
        // 初始化
        NSDictionary *dic = [DDTransformation returnDictionaryWithData:data];
        
        [self.originTipsArr addObject:dic];
        
        customBtn *btn = [self createTipsWithFrame:CGRectMake(KScreen_Width * 13 / 15.0 - finalW * 0.5 - 10, KScreen_Height * 0.2 + 40 + (self.originTipsArr.count - 1) * (tipsH + 10), finalW, tipsH) finalRect:CGRectMake(tipsX, tipsY, finalW, tipsH) tag:5 isOrigin:YES];
        
        btn.buildDate = dic[@"littleBuildTime"];
        
        [self.tipArr addObject:btn];
        
    }];
    
}

#pragma mark - 长按时间轴按钮开始编辑
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    // 处于编辑状态
    _timeLine.backgroundColor = [UIColor redColor];
    
    [MySingleTon shareSingleTon].isEditting = YES;
    _frame = [CAKeyframeAnimation animation];
    
    _frame.keyPath = @"transform.rotation";
    
    _frame.duration = 1.0;
    _frame.repeatCount = MAXFLOAT;
    
    // 时间轴按钮
    CGFloat left = - M_PI_2 * 0.2;
    CGFloat right = M_PI_2 * 0.2;
    _frame.values = @[@(left),@(right),@(left),@(right),@(left),@(right),@(left)];
    [_timeLineBtn.layer addAnimation:_frame forKey:@"transform.rotation"];
    
    for(customBtn *btn in self.tipArr)
    {
        NSInteger count = arc4random() % 200 + 10;
        CGFloat temp = 1.0 / count;
        CGFloat left = - M_PI_2 * temp;
        CGFloat right = M_PI_2 * temp;
        _frame.values = @[@(left),@(right),@(left),@(right),@(left),@(right),@(left)];
        [btn.layer addAnimation:_frame forKey:@"transform.rotation"];
    }
    // 默认
    NSInteger count = arc4random() % 200 + 10;
    CGFloat temp = 1.0 / count;
    left = - M_PI_2 * temp;
    right = M_PI_2 * temp;
    _frame.values = @[@(left),@(right),@(left),@(right),@(left),@(right),@(left)];
}

#pragma mark - 轻拍timeLineBtn结束抖动
- (void)tapTimeLineBtn:(UITapGestureRecognizer *)tapGesture
{
    _timeLine.backgroundColor = [UIColor colorWIthTimeLine];
    // 让时间轴上的按钮结束抖动效果
    for(customBtn *btn in self.tipArr)
    {
        [btn.layer removeAnimationForKey:@"transform.rotation"];
    }
    [_timeLineBtn.layer removeAnimationForKey:@"transform.rotation"];
    [MySingleTon shareSingleTon].isEditting = NO;
}

#pragma mark 关键帧动画
- (void)translationAnimation:(CGPoint)center withLayer:(CALayer *)layer withIndex:(NSInteger)index{
    
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.delegate = self;
    
    //  removedOnCompletion：默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards .
    // fillMode：决定当前对象在非active时间段的行为.比如动画开始之前,动画结束之后 .
    
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    keyframeAnimation.rotationMode = [NSString stringWithFormat:@"%ld", index];
    //2.设置路径
    // 绘制贝塞尔曲线
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);//移动到起始点
    CGPathAddCurveToPoint(path, NULL, center.x - 150, center.y + KScreen_Height / 3, center.x + 150, center.y + KScreen_Height * 2/ 3, center.x - 150, center.y + KScreen_Height);// 绘制二次贝塞尔曲线
    keyframeAnimation.path = path;// 设置path属性
    CGPathRelease(path);// 释放路径对象
    
    // 设置其他属性
    keyframeAnimation.duration = (KScreen_Height - center.y) * 0.01;
    
    // 3.添加动画到图层，添加动画后就会执行动画,注意key相当于给动画进行命名，以后获得该图层时可以使用此名称获取
    [layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
}

#pragma mark 旋转动画
- (void)rotationAnimation:(CALayer *)layer{
    //1.创建动画并指定动画属性
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //2.设置动画属性初始值、结束值
    //    basicAnimation.fromValue=[NSNumber numberWithInt:M_PI_2];
    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI_2*3];
    //设置其他动画属性
    basicAnimation.duration = 6.0;
    basicAnimation.autoreverses = true;//旋转后在旋转到原来的位置
    basicAnimation.repeatCount = HUGE_VALF;//设置无限循环
    basicAnimation.removedOnCompletion = NO;
//    basicAnimation.delegate = self;
    
    //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
}

#pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    CGContextSaveGState(ctx);
    
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, - 480);
    UIImage *image = [UIImage imageNamed:@"背景"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, 320, 480), image.CGImage);

    CGContextRestoreGState(ctx);
}

// 动画结束，移除layer
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAKeyframeAnimation *animation = (CAKeyframeAnimation *)anim;
    
    // 绑定的animation和layer的参数rotationMode
    NSString *str = animation.rotationMode;
    
    CALayer *layer = self.layerArr[[str integerValue]];
    
    [layer removeFromSuperlayer];
    [layer removeAllAnimations];
    
}

// 点击书钉，生成便条
- (void)didClickNailsToCreateTips:(UIButton *)btn
{
    [_nailsBtn setBackgroundColor:[UIColor colorWithBookNailsHighLighted]];
    [UIView animateWithDuration:1.0 animations:^{
        for(UIButton *tips in _btnArray)
        {
            [self.view insertSubview:tips belowSubview:_nailsBtn];
            // 设置锚点，frame
            tips.layer.anchorPoint = CGPointMake(0, 0.5);
            tips.frame = CGRectMake(tipsX, tipsY, finalW, tipsH);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            for(NSInteger i = 0; i < _btnArray.count; i ++)
            {
                // 旋转动画
                UIButton *tips = _btnArray[i];

                tips.transform = CGAffineTransformMakeRotation((i - 2) * M_PI / 8.0);
            }
        }];
        [_nailsBtn setBackgroundColor:[UIColor colorWithBookNails]];
    }];

    // 书钉置为不可点击
    _nailsBtn.enabled = NO;
}

// 弹出标签编辑栏
-(void)pressedShowCCMPlayNDropView:(customBtn *)btn{
    
    // 在时间轴上
    btn.isOnLine = YES;
    
    // tag赋值
    [MySingleTon shareSingleTon].tipType = btn.tag;
    
    PlayNDropViewController *popin = [[PlayNDropViewController alloc] init];
    
    popin.block = ^
    {
         // UILabel消失
        __weak UILabel *label = self.infoLabel;
        [UIView animateWithDuration:1.0 animations:^{
            label.frame = CGRectMake(KScreen_Width, (KScreen_Height - 200) * 0.5, 20, 200);
            label.hidden = YES;
        }];
    };
    
    popin.popinOptions = BKTPopinDisableAutoDismiss;
    
    popin.tipArr = [NSMutableArray arrayWithArray:self.tipArr];
    
    popin.view.bounds = CGRectMake(0, 0, 300, 400);
    
    //[popin setPopinOptions:BKTPopinDisableAutoDismiss];
    BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
    //blurParameters.alpha = 0.5;
    blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    blurParameters.radius = 0.3;
    [popin setBlurParameters:blurParameters];
    if(btn.tag == 5)
    {
        [popin setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
        [popin setPopinTransitionDirection:1];
    }else
    {
        [popin setPopinTransitionStyle:BKTPopinTransitionStyleSnap];
        [popin setPopinTransitionDirection:btn.tag - 1];
    }
//    popin.presentingController = self;
    
    //Present popin on the desired controller
    //Note that if you are using a UINavigationController, the navigation bar will be active if you present
    // the popin on the visible controller instead of presenting it on the navigation controller
    
    [self presentPopinController:popin animated:YES completion:^{

        // UILabel显示
        [UIView animateWithDuration:1.0 animations:^{
            self.infoLabel.hidden = NO;
            self.infoLabel.frame = CGRectMake(KScreen_Width - 20, (KScreen_Height - 200) * 0.5, 20, 200);
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
