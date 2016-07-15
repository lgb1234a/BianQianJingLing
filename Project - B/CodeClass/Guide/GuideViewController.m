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
#import "CustomPlayerView.h"
#import "SCGIFImageView.h"

@interface GuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GuideView *guideView;
@property (nonatomic, strong) UIPageControl *pageControl;


// 视频播放器
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer     *player;
@property (nonatomic, copy  ) CustomPlayerView *customPlayerView; // 播放器layer层
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *panels;


@end

@implementation GuideViewController


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
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 80) * 0.5, self.view.bounds.size.height - 80, 80, 30)];
    self.pageControl.tintColor = [UIColor blueColor];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
}


- (NSMutableArray *)panels
{
    if(_panels == nil)
    {
        self.panels = [NSMutableArray array];
    }
    return _panels;
}


// 定时器方法,循环播放
- (void)fireTimer
{
    if (_customPlayerView.player.rate == 0.0)
    {
        [_customPlayerView.player seekToTime:CMTimeMake(0, 1)];
        //        _customPlayerView.player.rate = 1.0;
        [_customPlayerView.player play];
    }
}

// page
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.hidden = NO;
    NSInteger page = scrollView.contentOffset.x / self.view.bounds.size.width;
    NSInteger currentOffset = (NSInteger)scrollView.contentOffset.x % (NSInteger)self.view.bounds.size.width;
    if(currentOffset > self.view.bounds.size.width * 0.5)
    {
        self.pageControl.currentPage = page + 1;
        
    }else if(currentOffset < self.view.bounds.size.width * 0.5)
    {
        self.pageControl.currentPage = page;
    }
    if(self.pageControl.currentPage == 4)
    {
        self.pageControl.hidden = YES;
    }
    
    [self initLayerout];
    
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
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:model.image ofType:nil];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        _guideView.gifData = imageData;
        
        if (i != 4)
        {
            _guideView.tapInBtn.hidden = YES;
        }else
        {
            _guideView.tapInBtn.hidden = NO;
            [_guideView.tapInBtn setTitle:model.button forState:UIControlStateNormal];
        }
    }
}

// 播放
- (void)initPlayer:(NSString *)filePath
{
//
    
//
//    [_guideView.imgView addSubview:_customPlayerView];
//    
//    
//    // 使用playerItem获取视频的信息，当前播放时间，总时间等
//    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:filePath]];
//    // player是视频播放的控制器，可以用来快进播放，暂停等
//    _player = [AVPlayer playerWithPlayerItem:_playerItem];
//    
//    [_customPlayerView setPlayer:_player];
//    
//    [_customPlayerView.player play];
}

// 进入主页面
- (void)tapIntoHomeVC:(UIButton *)btn
{
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
    
    ViewController *rootVC= [[ViewController alloc] init];
    WeatherViewController *weatherVC = [[WeatherViewController alloc] initWithCollectionViewLayout:layout];
    NoteViewController *noteVC = [[NoteViewController alloc] initWithCollectionViewLayout:layout];
    NotificationViewController *notificationVC = [[NotificationViewController alloc] initWithCollectionViewLayout:layout];
    AccountViewController *accountVC = [[AccountViewController alloc] initWithCollectionViewLayout:layout];
    RestDayViewController *restDayVC = [[RestDayViewController alloc] initWithCollectionViewLayout:layout];
    
    NSArray *array = @[rootVC, weatherVC, noteVC, notificationVC, accountVC, restDayVC];
    
    SPNavigationController *rootNv = [[SPNavigationController alloc]init];
    rootNv.viewControllers = array;
    
    [self presentViewController:rootNv animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
