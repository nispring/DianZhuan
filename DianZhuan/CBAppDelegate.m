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

#import "AppConnect.h"

#import "MobClick.h"

@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //修改navigation字体
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:
                        [NSArray arrayWithObjects:[UIColor orangeColor],[UIFont boldSystemFontOfSize:20],[UIColor clearColor],nil] forKeys:
                        [NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithFileName:IOS_7?@"navigationbar":@"navigationbar_44"] forBarMetrics:UIBarMetricsDefault];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        //保存在keychain
        [CBKeyChain save:TOTOLINTEGRAL data:@"10000"];
        [CBKeyChain save:INCOME data:@"10000"];
        [CBKeyChain save:EXPEND data:@"0"];
        [CBKeyChain save:YOUMI data:@"0"];
        [CBKeyChain save:CHUKONG data:@"0"];
        [CBKeyChain save:DUOMENG data:@"0"];
        [CBKeyChain save:WANPU data:@"0"];
        [CBKeyChain save:MOPAN data:@"0"];
        [[RecordManager sharedRecordManager] updateRecordWithContent:@"首次赠送积分" andIntegral:@"+10000"];

        //上传bmob User表
        BmobObject *bmob = [BmobObject objectWithClassName:@"Users"];
        [bmob setObject:@"10000" forKey:TOTOLINTEGRAL];
        [bmob setObject:@"10000" forKey:INCOME];
        [bmob setObject:@"0" forKey:EXPEND];
        [bmob setObject:@"0" forKey:YOUMI];
        [bmob setObject:@"0" forKey:CHUKONG];
        [bmob setObject:@"0" forKey:DUOMENG];
        [bmob setObject:@"0" forKey:WANPU];
        [bmob setObject:@"0" forKey:MOPAN];
        [bmob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
                //记录唯一标示用户
                [CBKeyChain save:USERID data:bmob.objectId];
                
                //上传bmob IncomeRecord表
                BmobObject *gameScore = [BmobObject objectWithClassName:@"IncomeRecord"];
                [gameScore setObject:[CBKeyChain load:USERID] forKey:@"userId"];
                [gameScore setObject:@"初始积分" forKey:@"adType"];
                [gameScore setObject:@"10000" forKey:@"integral"];
                [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                }];
            }

        }];
        
    }else{
        
    }
    [self initConfig];
    return YES;
}

- (void)initConfig{
    
    //友盟
    [MobClick startWithAppkey:@"53a2726456240bfb7f01b872" reportPolicy:SEND_INTERVAL   channelId:nil];
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    //有米
    [YouMiConfig setUseInAppStore:YES];  // [可选]开启内置appStore，详细请看YouMiSDK常见问题解答
    [YouMiConfig launchWithAppID:@"5a48640be63febb1" appSecret:@"67ed4b5d4db14682"];
    [YouMiConfig setFullScreenWindow:self.window];
    
    //触控
    [PunchBoxAd startSession:@"100032-4CE817-ABA2-5B48-14D009296720"];
    
    //万普
    [AppConnect getConnect:@"38718de31b979ca9792dd462523c68c2" pid:@"appstore"];
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
