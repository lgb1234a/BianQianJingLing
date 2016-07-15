//
//  RestDayViewController.m
//  Project - B
//
//  Created by lcy on 15/10/27.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "RestDayViewController.h"
#import "TGLCollectionViewCell.h"
#import "UIColor+ThemeColor.h"
#import "PKDataBaseManage.h"
#import "RestdayDetailCollectionViewCell.h"
#import "DDTransformation.h"
#import "NSDate+CalculateTimeLocal.h"

@interface UIColor (randomColor)

+ (UIColor *)randomColor;

@end

@implementation UIColor (randomColor)

+ (UIColor *)randomColor {
    
    CGFloat comps[3];
    
    for (int i = 0; i < 3; i++) {
        
        NSUInteger r = arc4random_uniform(256);
        comps[i] = (CGFloat)r/255.f;
    }
    
    return [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
}

@end


@interface RestDayViewController ()

@property (strong, nonatomic) NSMutableArray *cards;

@end



@implementation RestDayViewController

@synthesize cards = _cards;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor magentaColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KScreen_Width, 20, 50, 30)];
    label.backgroundColor = [UIColor colorWithRestDay];
    label.text = @"剩余日";
    [self.view addSubview:label];
    
    self.collectionView.backgroundColor = [UIColor colorWithRestDay];
    
    //    TGLStackedLayout *layout = [[TGLStackedLayout alloc] init];
    //    self.collectionView = [[TGLStackedViewController alloc] initWithCollectionViewLayout:layout];
    
    
    // Set to NO to prevent a small number
    // of cards from filling the entire
    // view height evenly and only show
    // their -topReveal amount
    //
    self.stackedLayout.fillHeight = YES;
    
    // Set to NO to prevent a small number
    // of cards from being scrollable and
    // bounce
    //
    self.stackedLayout.alwaysBounce = YES;
    
    // Set to NO to prevent unexposed
    // items at top and bottom from
    // being selectable
    //
    self.unexposedItemsAreSelectable = YES;
    
    
    [self.collectionView registerClass:[RestdayDetailCollectionViewCell class] forCellWithReuseIdentifier:@"CardCell"];
    
    // 添加数据后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restDayNewChange:) name:@"restDay" object:nil];
    
    // 删除数据后刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restDayDeleteCell) name:@"restDayDeleteCell" object:nil];
    
//    [PKDataBaseManage DBManage:nil tableName:restDayTableName dataName:nil manageType:dataBaseManageTypeDeleteAllData getDataFromDict:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Accessors

- (NSMutableArray *)cards {
    
    if (_cards == nil) {
        
        self.cards = [NSMutableArray array];
        
        [PKDataBaseManage DBManage:nil tableName:restDayTableName dataName:nil manageType:dataBaseManageTypeQueryAllData getDataFromDict:^(NSData *data) {
            // 初始化
            NSDictionary *dic = [DDTransformation returnDictionaryWithData:data];
            
            [self.cards addObject:dic];
            
        }];
        
    }
    
    return _cards;
}

#pragma mark - 接收到存储数据
- (void)restDayNewChange:(NSNotification *)notification
{
    [PKDataBaseManage DBManage:nil tableName:restDayTableName dataName:notification.userInfo[@"buildTime"] manageType:dataBaseManageTypeQueryData getDataFromDict:^(NSData *data) {

        NSDictionary *dic = [DDTransformation returnDictionaryWithData:data];

        [self.cards addObject:dic];
    }];
    [self.collectionView reloadData];
}

- (void)restDayDeleteCell
{
    [self.cards removeAllObjects];
    [PKDataBaseManage DBManage:nil tableName:restDayTableName dataName:nil manageType:dataBaseManageTypeQueryAllData getDataFromDict:^(NSData *data) {
        // 初始化
        NSDictionary *dic = [DDTransformation returnDictionaryWithData:data];
        
        [self.cards addObject:dic];
        
    }];
    [self.collectionView reloadData];
}

#pragma mark - CollectionViewDataSource protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RestdayDetailCollectionViewCell *cell = (RestdayDetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    NSDictionary *card = self.cards[indexPath.item];
    
    cell.title = card[@"littleBuildTime"];
//    cell.color = [UIColor colorWithRestDay];
    cell.descLabel.text = card[@"desc"];
    
    // 时间转换
    NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSDate *buildDate = [formatter dateFromString:card[@"buildDate"]];
    buildDate = [NSDate getNowDateFromatAnDate:buildDate];
    
    NSDate *seriousDate = [formatter dateFromString:card[@"date"]];
    seriousDate = [NSDate getNowDateFromatAnDate:seriousDate];
    
    NSTimeInterval time = [buildDate timeIntervalSinceDate:seriousDate];
    NSInteger betWeeenTime = time / 86400;
    
    // 时间差
    NSString *str;
    if(betWeeenTime > 0)
    {
        str = [NSString stringWithFormat:@"已经过去了%ld天", betWeeenTime];
    }else
    {
        str = [NSString stringWithFormat:@"还有%ld天", -betWeeenTime];
    }
    
    cell.daysLabel.text = str;
    
    cell.dateLabel.text = card[@"date"];
    
    return cell;
}

#pragma mark - Overloaded methods

- (void)moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Update data source when moving cards around
    //
    NSDictionary *card = self.cards[fromIndexPath.item];
    
    [self.cards removeObjectAtIndex:fromIndexPath.item];
    [self.cards insertObject:card atIndex:toIndexPath.item];
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
