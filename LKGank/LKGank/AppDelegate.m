//
//  AppDelegate.m
//  LKGank
//
//  Created by Stephen on 2017/4/6.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "AppDelegate.h"
#import "GankNavigationController.h"
#import "GankMainViewController.h"
#import "GankHomeViewController.h"
#import "HttpManager.h"
#import <SDWebImage/SDImageCache.h>

#import <UMSocialCore/UMSocialCore.h>
#import <BmobSDK/Bmob.h>

#import "GankGuidePageController.h"
#import "GankNavigationController.h"
#import "GankHomeViewController.h"
#import "GankMainViewController.h"
#import <BmobSDK/Bmob.h>

#define UmengKey @"597caea45312dd3a80000263"

#define BmobKey @"9285145070f1db0f2061adeadd22c267"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ShareHttpManager startNotifierReachability];
    
    //===umeng=分享=
    [self setUmeng];
    [self configUSharePlatforms];
     //===umeng==
    //===umeng=统计=
    [self setUmengShare];
    //===umeng==
    
    //===bmob==
    [self setBmob];
    //===bmob==
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self chooseRootViewController];
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
    [[SDImageCache sharedImageCache] clearMemory];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma -mark- BmobKey
-(void)setBmob
{
    [Bmob registerWithAppKey:BmobKey];
    
    BmobQuery *bquery=[BmobQuery queryWithClassName:@"categoryTab"];
    [bquery orderByAscending:@"createdAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray *arr=[NSMutableArray array];
        for (BmobObject *obj in array) {
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            if ([obj objectForKey:@"name"]) {
                dict[@"name"]=[obj objectForKey:@"name"];
            }
            if ([obj objectForKey:@"url"]) {
                dict[@"url"]=[obj objectForKey:@"url"];
            }
            [arr addObject:dict];
        }
        
        //输入写入
        [arr writeToFile:PathCategory atomically:YES];
        
    }];
    
  
}




#pragma -mark- Umeng 分享
//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


#pragma -mark- umeng share
-(void)setUmengShare
{
    UMConfigInstance.appKey = UmengKey;
    UMConfigInstance.channelId = @"AppStoreCloud";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
  
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

#pragma -mark-  Umeng
-(void)setUmeng
{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengKey];
    
    
}
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1627a614208105e5" appSecret:@"78e8f64b0c783c11a987c0a8376e63e5" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106320100"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2855525464"  appSecret:@"5da6a892d9eb4e5485cf47729933cd51" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}


#pragma -mark-  chooseRootViewController
- (void)chooseRootViewController
{
    // 如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    //
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        GankHomeViewController *homeVc=[[GankHomeViewController alloc] init];;
        GankNavigationController *navVc=[[GankNavigationController alloc] initWithRootViewController:homeVc];
        GankMainViewController *mainVc=[[GankMainViewController alloc] init];;
        mainVc.rootViewController=navVc;
        window.rootViewController=mainVc;
    } else {
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
        window.rootViewController = [[GankGuidePageController alloc] init];
        
    }
}


@end
