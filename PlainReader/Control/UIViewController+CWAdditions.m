//
//  UIViewController+CWAdditions.m
//  PlainReader
//
//  Created by guo on 5/10/15.
//  Copyright (c) 2015 GUOJIUBO. All rights reserved.
//

#import "UIViewController+CWAdditions.h"

@implementation UIViewController (CWAdditions)

+ (instancetype)cw_loadFromNibUsingClassName
{
    // Swift's class name is in the form of module.className
    NSString *nibName = [[NSStringFromClass(self) componentsSeparatedByString:@"."] lastObject];
    return [[self alloc] initWithNibName:nibName bundle:nil];
}

@end
