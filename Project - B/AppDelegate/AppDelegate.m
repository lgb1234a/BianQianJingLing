//
//  AppDelegate.m
//  Project - B
//
//  Created by lcy on 15/10/15.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "ViewController.h"
#import "WeatherViewController.h"
#import "NoteViewController.h"
#import "NotificationViewController.h"
#import "AccountViewController.h"
#import "RestDayViewController.h"
#import "SPNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 初始化标签状态
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"onLine"];
    [NSThread sleepForTimeInterval:1.0];
    
    
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
//    if([[NSUserDefaults standardUserDefaults] boolForKey:notFresh])
//    {
//        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
//        
//        ViewController *rootVC= [[ViewController alloc] init];
//        WeatherViewController *weatherVC = [[WeatherViewController alloc] initWithCollectionViewLayout:layout];
//        NoteViewController *noteVC = [[NoteViewController alloc] initWithCollectionViewLayout:layout];
//        NotificationViewController *notificationVC = [[NotificationViewController alloc] initWithCollectionViewLayout:layout];
//        AccountViewController *accountVC = [[AccountViewController alloc] initWithCollectionViewLayout:layout];
//        RestDayViewController *restDayVC = [[RestDayViewController alloc] initWithCollectionViewLayout:layout];
//        
//        NSArray *array = @[rootVC, weatherVC, noteVC, notificationVC, accountVC, restDayVC];
//        
//        SPNavigationController *rootNv = [[SPNavigationController alloc]init];
//        rootNv.viewControllers = array;
//        
//        _window.rootViewController = rootNv;
//    }else
//    {
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        _window.rootViewController = guideVC;
//    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:notFresh];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
