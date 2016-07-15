//
//  WeatherViewController.m
//  Project - B
//
//  Created by lcy on 15/10/27.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "WeatherViewController.h"
#import "TGLCollectionViewCell.h"
#import "UIColor+ThemeColor.h"
#import "PKDataBaseManage.h"
#import "FutureTemperatureModel.h"
#import "WeatherDetailCollectionViewCell.h"

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


@interface WeatherViewController () 

@property (strong, nonatomic) NSMutableArray *cards;


//@property (nonatomic, strong)NSMutableArray *futureWeather; // 未来几日天气

@end



@implementation WeatherViewController

@synthesize cards = _cards;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor magentaColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KScreen_Width, 20, 50, 30)];
    label.backgroundColor = [UIColor colorWithWeather];
    label.text = @"天气";
    [self.view addSubview:label];
    
    self.collectionView.backgroundColor = [UIColor colorWithWeather];
    
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
    
    [self.collectionView registerClass:[WeatherDetailCollectionViewCell class] forCellWithReuseIdentifier:@"CardCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCards) name:@"weatherChange" object:nil];
    
    [self updateCards];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}


#pragma mark - Accessors

- (NSMutableArray *)cards {
    
    if (_cards == nil) {
        
        self.cards = [NSMutableArray array];
        
    }
    
    return _cards;
}

// 接收到要刷新数据源消息时调用
- (void)updateCards
{
    [PKDataBaseManage DBManage:nil tableName:weatherTableName dataName:@"weather" manageType:dataBaseManageTypeQueryData getDataFromDict:^(NSData *data) {
        
        if(data != nil)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            
            // 未来天气
            [self.cards removeAllObjects];
            
            for (NSDictionary *diction in dic[@"result"][@"future"]) {
                FutureTemperatureModel *futureModel = [[FutureTemperatureModel alloc] init];
                [futureModel setValuesForKeysWithDictionary:diction];
                [self.cards addObject:futureModel];
            }
            [self.collectionView reloadData];
        }
        
        
    }];
}


#pragma mark - CollectionViewDataSource protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WeatherDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    FutureTemperatureModel *model = self.cards[indexPath.item];
    
    cell.title = model.date;
//    cell.color = [UIColor colorWithWeather];
    
    cell.weekLabel.text = model.week;
    cell.temperatureLabel.text = model.temperature;
    cell.weatherLabel.text = model.weather;
    cell.windLabel.text = model.wind;
    
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
