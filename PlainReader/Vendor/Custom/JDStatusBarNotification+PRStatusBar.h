//
//  JDStatusBarNotification+CBStatusBar.h
//  PlainReader
//
//  Created by guojiubo on 14-6-3.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "JDStatusBarNotification.h"

@interface JDStatusBarNotification (PRStatusBar)

+ (UIView *)showSuccess:(NSString *)message;

+ (UIView *)showSuccess:(NSString *)message dismissAfter:(NSTimeInterval)delay;

+ (UIView *)showError:(NSString *)message;

+ (UIView *)showError:(NSString *)message dismissAfter:(NSTimeInterval)delay;

@end
