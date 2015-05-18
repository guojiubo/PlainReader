//
//  AppDelegate.h
//  PlainReader
//
//  Created by guojiubo on 14-3-20.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const AppDelegateSideMenuDidShowNotification;
extern NSString *const AppDelegateSideMenuDidHideNotification;
extern NSString *const AppDelegateSideMenuDidTriggerShowNotification;
extern NSString *const AppDelegateSideMenuDidTriggerHideNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;

@end
