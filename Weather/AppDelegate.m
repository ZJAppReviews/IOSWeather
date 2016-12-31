//
//  AppDelegate.m
//  Weather
//
//  Created by F&Easy on 16/10/11.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import "AppDelegate.h"
#import "ShowWeatherViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //通过屏幕尺寸初始化应用窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    
    ShowWeatherViewController *showWeatherViewController = [[ShowWeatherViewController alloc]init];
    UINavigationController *rootViewController = [[UINavigationController alloc]initWithRootViewController:showWeatherViewController];
    
    
    //取到navigationbar的单例对象，用于设置导航栏的标题颜色，背景
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置标题文字的颜色
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置导航栏的背景颜色，颜色从图片中取出
    bar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    
    [self.window setRootViewController:rootViewController];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
