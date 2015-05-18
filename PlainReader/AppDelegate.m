//
//  AppDelegate.m
//  PlainReader
//
//  Created by guojiubo on 14-3-20.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "AppDelegate.h"
#import "PRURLCache.h"
#import "PRHTTPURLProtocol.h"
#import "PRRealtimeViewController.h"
#import "PRActivityMonitor.h"
#import "PRDatabase.h"
#import "PRAppearanceManager.h"
#import "PRStackController.h"
#import "PRCustomURLProtocol.h"

NSString *const AppDelegateSideMenuDidShowNotification = @"AppDelegateSideMenuDidShowNotification";
NSString *const AppDelegateSideMenuDidHideNotification = @"AppDelegateSideMenuDidHideNotification";
NSString *const AppDelegateSideMenuDidTriggerShowNotification = @"AppDelegateSideMenuDidTriggerShowNotification";
NSString *const AppDelegateSideMenuDidTriggerHideNotification = @"AppDelegateSideMenuDidTriggerHideNotification";

@interface AppDelegate () <RESideMenuDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PRLogger setup];
    
    [[PRDatabase sharedDatabase] prepareDatabase];
    
    [NSURLCache setSharedURLCache:[[PRURLCache alloc] init]];
    [NSURLProtocol registerClass:[PRHTTPURLProtocol class]];
    [NSURLProtocol registerClass:[PRCustomURLProtocol class]];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[CWObjectCache sharedCache] setMaxCacheSize:1024 * 1024 * 256];
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    PRRealtimeViewController *realtime = [PRRealtimeViewController cw_loadFromNibUsingClassName];
    LeftMenuViewController *leftMenu = [LeftMenuViewController cw_loadFromNibUsingClassName];
    PRStackController *stackController = [[PRStackController alloc] initWithRootViewController:realtime];
    
    RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:stackController leftMenuViewController:leftMenu rightMenuViewController:nil];
    sideMenu.delegate = self;
    sideMenu.panFromEdge = NO;
    sideMenu.fadeMenuView = NO;
    sideMenu.parallaxEnabled = NO;
    sideMenu.scaleBackgroundImageView = NO;
    sideMenu.scaleContentView = NO;
    sideMenu.scaleMenuView = NO;
    
    [self.window setRootViewController:sideMenu];
    [self.window setBackgroundColor:[UIColor whiteColor]];
        
#ifdef DEBUG
//    [[PRActivityMonitor sharedMonitor] start];
#endif
    
    [[PRAppearanceManager sharedManager] setup];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[PRDatabase sharedDatabase] clearExpiredArticles:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PRDatabase sharedDatabase] clearExpiredArticles:nil];
}

#pragma mark - RESideMenuDelegate

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    [[NSNotificationCenter defaultCenter] cw_postNotificationOnMainThreadName:AppDelegateSideMenuDidShowNotification sender:self userObject:nil];
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    [[NSNotificationCenter defaultCenter] cw_postNotificationOnMainThreadName:AppDelegateSideMenuDidHideNotification sender:self userObject:nil];
}

- (void)didTriggerShowSideMenu:(RESideMenu *)sideMenu
{
    [[NSNotificationCenter defaultCenter] cw_postNotificationOnMainThreadName:AppDelegateSideMenuDidTriggerShowNotification sender:self userObject:nil];
}

- (void)didTriggerHideSideMenu:(RESideMenu *)sideMenu
{
    [[NSNotificationCenter defaultCenter] cw_postNotificationOnMainThreadName:AppDelegateSideMenuDidTriggerHideNotification sender:self userObject:nil];
}

@end
