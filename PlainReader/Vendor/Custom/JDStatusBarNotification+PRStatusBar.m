//
//  JDStatusBarNotification+CBStatusBar.m
//  PlainReader
//
//  Created by guojiubo on 14-6-3.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "JDStatusBarNotification+PRStatusBar.h"

static NSString *const CBStatusBarStyleSuccess = @"CBStatusBarStyleSuccess";

@implementation JDStatusBarNotification (CBStatusBar)

+ (UIView *)showSuccess:(NSString *)message
{
    return [self showSuccess:message dismissAfter:3.0];
}

+ (UIView *)showSuccess:(NSString *)message dismissAfter:(NSTimeInterval)delay
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addStyleNamed:CBStatusBarStyleSuccess prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor pr_blueColor];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
    });
    
    return [JDStatusBarNotification showWithStatus:message dismissAfter:delay styleName:CBStatusBarStyleSuccess];
}

+ (UIView *)showError:(NSString *)message
{
    return [self showError:message dismissAfter:3.0];
}

+ (UIView *)showError:(NSString *)message dismissAfter:(NSTimeInterval)delay
{
    return [JDStatusBarNotification showWithStatus:message dismissAfter:delay styleName:JDStatusBarStyleError];
}

@end
