//
//  ViewController.m
//  引导页
//
//  Created by lcy on 15/11/3.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideView.h"
#import "Model.h"
#import "ViewController.h"
#import "WeatherViewController.h"
#import "NoteViewController.h"
#import "NotificationViewController.h"
#import "AccountViewController.h"
#import "RestDayViewController.h"
#import "SPNavigationController.h"
#import "AppDelegate.h"

@interface GuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GuideView *guideView;

@property (nonatomic, strong) NSMutableArray *panels;


@end

@implementation GuideViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.bounces = NO;
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 5, self.view.bounds.size.height);
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // 获取json数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"json"];
    NSData *panelData = [[NSData alloc] initWithContentsOfFile:path];
    
    if (panelData)
    {
        NSArray *panelDictionaries = [NSJSONSerialization JSONObjectWithData:panelData options:0 error:nil];
        
        /**
         *  Iterate the panel dictionaries and "inflate" them into objects.
         */
        
        for (NSDictionary *panelDictionary in panelDictionaries)
        {
            Model *panel = [[Model alloc] init];
            [panel setValuesForKeysWithDictionary:panelDictionary];
            [self.panels addObject:panel];
        }
    }
    
    [self initLayerout];
    
    [_guideView.tapInBtn addTarget:self action:@selector(tapIntoHomeVC:) forControlEvents:UIControlEventTouchUpInside];
}


- (NSMutableArray *)panels
{
    if(_panels == nil)
    {
        self.panels = [NSMutableArray array];
    }
    return _panels;
}

// 布局
- (void)initLayerout
{
    // 初始化页面
    for (int i = 0; i < self.panels.count; i++)
    {
        NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"Guide_View" owner:self options:nil];
        _guideView = [viewArr firstObject];
        
        _guideView.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
        [self.scrollView addSubview:_guideView];
        
        // 取出model
        Model *model = self.panels[i];
        
        if(model.button.length == 0)
        {
            _guideView.tapInBtn.hidden = YES;
        }else
        {
            [_guideView.tapInBtn setTitle:model.button forState:UIControlStateNormal];
        }
        
        _guideView.introduce.text = model.text;
        
        _guideView.gifImage = model.image;
        _guideView.indexPageControl.currentPage = i;
        
        if (i != 4)
        {
            _guideView.tapInBtn.hidden = YES;
            _guideView.indexPageControl.hidden = !_guideView.tapInBtn.hidden;
        }else
        {
            _guideView.tapInBtn.hidden = NO;
            _guideView.indexPageControl.hidden = !_guideView.tapInBtn.hidden;
            [_guideView.tapInBtn setTitle:model.button forState:UIControlStateNormal];
        }
    }
}

// 进入主页面
- (void)tapIntoHomeVC:(UIButton *)btn
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate gotoHomeViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
