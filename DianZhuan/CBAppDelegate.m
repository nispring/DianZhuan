//
//  CBAppDelegate.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "CBAppDelegate.h"


#import "MainViewController.h"

#import "YouMiConfig.h"

#import "PunchBoxAd.h"

#import "MiidiManager.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = mainNav;

    [self.window makeKeyAndVisible];
    
    
    //有米
    [YouMiConfig setUseInAppStore:YES];  // [可选]开启内置appStore，详细请看YouMiSDK常见问题解答
    [YouMiConfig launchWithAppID:@"5a48640be63febb1" appSecret:@"67ed4b5d4db14682"];
    [YouMiConfig setFullScreenWindow:self.window];
    
    //触控
    [PunchBoxAd startSession:@"100032-4CE817-ABA2-5B48-14D009296720"];

    //米迪
    [MiidiManager setAppPublisher:@"17820"  withAppSecret:(NSString *)@"9herzd6l8aaj2q5t" ];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
