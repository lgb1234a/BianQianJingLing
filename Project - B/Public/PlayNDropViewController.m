//
//  PlayNDropViewController.m
//  CCMPlayNDropViewSample
//
//  Created by Compean on 29/11/14.
//  Copyright (c) 2014 Carlos Compean. All rights reserved.
//

#import "PlayNDropViewController.h"
#import <MaryPopin/UIViewController+MaryPopin.h>
#import "CCMPlayNDropView.h"
#import "HSDatePickerViewController.h"
#import "DatePickerViewController.h"
#import "customBtn.h"
#import "MySingleTon.h"
#import "PKDataBaseManage.h"
#import "PKRequestManager.h"
#import "TodayTemperatureModel.h"
#import "CurrentWeatherModel.h"
#import "NSDate+CalculateTimeLocal.h"
#import "DDTransformation.h"
#import <CoreLocation/CoreLocation.h>
@interface PlayNDropViewController () <HSDatePickerViewControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic)CCMPlayNDropView *dropView;
//@property (strong, nonatomic)MGConferenceDatePicker *datePicker;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign)BOOL willSaved;  // 判断是否保存，用于判断popin弹出方式
@property (nonatomic, strong)NSData *weatherData;  // 存储天气
@property (nonatomic, strong)CLLocationManager *locationManager; // 定位
@property (nonatomic, strong)NSArray *cityArray;

@end

@implementation PlayNDropViewController

- (NSArray *)cityArray
{
    if(_cityArray == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        
        self.cityArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _cityArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dropView = [[CCMPlayNDropView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    
    [self.dropView.notificationView.chooseDate addTarget:self action:@selector(createChooseDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.dropView.weatherView.searchWeather addTarget:self action:@selector(searchWeather:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.dropView.backgroundColor = [UIColor whiteColor];
    self.dropView.delegate = self;
    
    [self.view addSubview:self.dropView];
}

// 创建时间选择器
- (void)createChooseDatePicker:(UIButton *)btn
{
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    if (self.selectedDate) {
        hsdpvc.date = self.selectedDate;
    }
    [self presentViewController:hsdpvc animated:YES completion:nil];
    
}

#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    self.dropView.notificationView.timeLabel.text = [dateFormater stringFromDate:date];
    self.selectedDate = date;
}

// 搜索天气
- (void)searchWeather:(UIButton *)btn
{
    WeatherTipView *tipView = self.dropView.weatherView;
    
    [tipView.cityTextField resignFirstResponder];
    
    
    NSDictionary *dict;
    if(tipView.cityTextField.text.length > 0 && ![tipView.cityTextField.text hasSuffix:@"省"] && ![tipView.cityTextField.text hasSuffix:@"市"])
    {
        // 拿到城市ID
        NSString *textFieldStr = [tipView.cityTextField.text copy];
        
        
        NSString *cityId;
        for(NSDictionary *cityDic in self.cityArray)
        {
            NSLog(@"%@", self.cityArray[0]);
            if([textFieldStr isEqualToString:cityDic[@"city"]])
            {
                cityId = cityDic[@"cityId"];
                break;
            }
        }
        NSString *path = [NSString stringWithFormat:@"https://api.heweather.com/x3/weather?cityid=%@&key=4aa212800dcf4e79b742fded3384b1f3", cityId];
        
//        dict = @{@"cityid":cityId, @"key":@"4aa212800dcf4e79b742fded3384b1f3"};
        
        [PKRequestManager requestWithType:RequestTypeGet urlStr:path parDic:nil finish:^(NSData *data) {
            // 存储天气
            self.weatherData = data;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            //        NSLog(@"%@", dic);
            if(![dic[@"reason"] isEqualToString:@"成功"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:dic[@"reason"] delegate:tipView cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else
            {
                // 今日
                TodayTemperatureModel *todayModel = [[TodayTemperatureModel alloc] init];
                [todayModel setValuesForKeysWithDictionary:dic[@"result"][@"today"]];
                
                tipView.dateLabel.text = todayModel.date_y;
                
                tipView.temperature.text = [NSString stringWithFormat:@"温度：%@", todayModel.temperature];
                
                tipView.locatedCity.text = [NSString stringWithFormat:@"当前城市：%@", tipView.cityTextField.text];
                
                tipView.weather.text = [NSString stringWithFormat:@"天气：%@", todayModel.weather];
                
                tipView.uv_index.text = [NSString stringWithFormat:@"紫外线：%@", todayModel.uv_index];
                
                
                // 当前
                CurrentWeatherModel *currentModel = [[CurrentWeatherModel alloc] init];
                [currentModel setValuesForKeysWithDictionary:dic[@"result"][@"sk"]];
                
                tipView.currentTimeLabel.text = currentModel.time;
                
                tipView.currentTemp.text = [NSString stringWithFormat:@"当前温度：%@", currentModel.temp];
                
                tipView.humidity.text = [NSString stringWithFormat:@"污染指数：%@", currentModel.humidity];
            }
            
            
        } error:^(NSError *error) {
            NSLog(@"%@", error.userInfo);
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
        }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入城市名称（不含省、市、自治区字样）" delegate:tipView cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}

// 拖拽时调用
- (void)CCMPlayNDropViewManualTraslationDidStart:(CCMPlayNDropView *)view
{
    // 发送提示
    NSLog(@"向右拖拽存储");
    
}

// 拖拽松手后调用
-(void)CCMPlayNDropViewWillStartDismissAnimationWithDynamics:(CCMPlayNDropView *)view
{
    
    self.block();
    
    self.view.superview.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    // 获取手势
    UIPanGestureRecognizer *pan = view.gestureRecognizers[0];
    CGFloat xTran = [pan translationInView:view].x;
    CGFloat yTran = [pan translationInView:view].y;
    if(xTran > 0 && (((xTran / yTran) > 0.8 || (xTran / yTran) < -0.8)))
    {
        // 存储
        NSLog(@"save down! %f, %f   %f", xTran, yTran, xTran / yTran);
        
        switch ([MySingleTon shareSingleTon].tipType) {
            case 1:// 天气   天气查询7天天气，并存储到本地
            {
                // 天气存储到本地
                [PKDataBaseManage DBManage:self.weatherData tableName:weatherTableName dataName:@"weather" manageType:dataBaseManageTypeStoreData getDataFromDict:nil];
                
                // 通知详情页面进行数据刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherChange" object:self];
            }
                break;
            case 2:// 提醒
            {
                NSDate *senddate=[NSDate date];
                NSDateFormatter *littleFromatter = [[NSDateFormatter alloc] init];
                [littleFromatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
                NSString *littleDateStr = [littleFromatter stringFromDate:senddate];
                
                if(view.notificationView.descripTextView.text.length == 0)
                {
                    view.notificationView.descripTextView.text = @"这里什么也没有记下.";
                }
                
                // 创建字典，将字典转成data，方便存入数据库
                NSDictionary *dic = @{@"desc":view.notificationView.descripTextView.text, @"buildTime":littleDateStr, @"date":view.notificationView.timeLabel.text};
                
                NSData *data = [DDTransformation returnDataWithDictionary:dic];
                // 笔记存储到本地
                [PKDataBaseManage DBManage:data tableName:notificationTableName dataName:littleDateStr manageType:dataBaseManageTypeStoreData getDataFromDict:nil];
                
                // 笔记详情页面进行数据刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:self userInfo:@{@"buildTime":littleDateStr}];
                
            }
                break;
            case 3:// 笔记
            {
                
                NSDate *senddate=[NSDate date];
                NSDateFormatter *littleFromatter = [[NSDateFormatter alloc] init];
                [littleFromatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
                NSString *littleDateStr = [littleFromatter stringFromDate:senddate];
                
                if(view.noteView.textView.text.length == 0)
                {
                    view.noteView.textView.text = @"是时候写点什么了.";
                }
                
                // 创建字典，将字典转成data，方便存入数据库
                NSDictionary *dic = @{@"desc":view.noteView.textView.text, @"buildTime":littleDateStr};
                
                NSData *data = [DDTransformation returnDataWithDictionary:dic];
                // 笔记存储到本地
                [PKDataBaseManage DBManage:data tableName:noteTableName dataName:littleDateStr manageType:dataBaseManageTypeStoreData getDataFromDict:nil];
                
                // 笔记详情页面进行数据刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:self userInfo:@{@"buildTime":littleDateStr}];
            }
                
                break;
            case 4:// 账本
            {
                
                NSDate *senddate=[NSDate date];
                NSDateFormatter *littleFromatter = [[NSDateFormatter alloc] init];
                [littleFromatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
                NSString *littleDateStr = [littleFromatter stringFromDate:senddate];
                
                if(view.accountView.descTextView.text.length == 0)
                {
                    view.accountView.descTextView.text = @"这里空空如也.";
                }
                
                // 创建字典，将字典转成data，方便存入数据库
                NSDictionary *dic;
                if(view.accountView.isOutcome)
                {
                    dic = @{@"desc":view.accountView.descTextView.text, @"buildTime":littleDateStr,@"outcome":view.accountView.outcomeTextField.text};
                }else
                {
                    
                    dic = @{@"desc":view.accountView.descTextView.text, @"buildTime":littleDateStr,@"income":view.accountView.incomeTextField.text};
                }
                
                
                NSData *data = [DDTransformation returnDataWithDictionary:dic];
                // 笔记存储到本地
                [PKDataBaseManage DBManage:data tableName:accountTableName dataName:littleDateStr manageType:dataBaseManageTypeStoreData getDataFromDict:nil];
                
                // 笔记详情页面进行数据刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"account" object:self userInfo:@{@"buildTime":littleDateStr}];
                
                
            }
                break;
            case 5:// 倒数日
            {
                
                NSDate *senddate=[NSDate date];
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"YYYY/MM/dd"];
                NSString *locationString=[dateformatter stringFromDate:senddate];
                
                NSDateFormatter *littleFromatter = [[NSDateFormatter alloc] init];
                [littleFromatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
                NSString *littleDateStr = [littleFromatter stringFromDate:senddate];
                
                // 倒数日
                NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY/MM/dd"];
                
                
                // 把输入的日期转成NSDate
                NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@/%@/%@", view.restDayTipView.yearTextField.text, view.restDayTipView.monthTextField.text, view.restDayTipView.dayTextField.text]];
                date = [NSDate getNowDateFromatAnDate:date];
                NSString *dateString=[formatter stringFromDate:date];
                
                // 创建字典，将字典转成data，方便存入数据库
                NSDictionary *dic = @{@"date":dateString, @"desc":view.restDayTipView.descripTextView.text, @"buildDate":locationString, @"littleBuildTime":littleDateStr};
                
                NSData *data = [DDTransformation returnDataWithDictionary:dic];
                // 剩余日存储到本地
                [PKDataBaseManage DBManage:data tableName:restDayTableName dataName:littleDateStr manageType:dataBaseManageTypeStoreData getDataFromDict:nil];
                
                // 剩余日详情页面进行数据刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"restDay" object:self userInfo:@{@"buildTime":littleDateStr}];
            }
                break;
                
            default:
                break;
        }
    }else
    {
        // 不保存
        customBtn *btn = (customBtn *)[_tipArr lastObject];
        [btn removeFromSuperview];
        
        [_tipArr removeLastObject];
    }
}



// 完成存储
-(void)CCMPlayNDropViewDidFinishDismissAnimationWithDynamics:(CCMPlayNDropView *)view{
    self.view.superview.userInteractionEnabled = YES;
    CGRect frame = self.view.frame;
    frame.origin.y = -1000;
    self.view.frame = frame;
    
    [self.parentViewController dismissCurrentPopinControllerAnimated:YES];
    
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
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com