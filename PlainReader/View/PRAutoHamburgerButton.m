//
//  PRAutoHamburgerButton.m
//  PlainReader
//
//  Created by guo on 11/29/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRAutoHamburgerButton.h"

@implementation PRAutoHamburgerButton

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleSideMenuDidShowNotification:) name:AppDelegateSideMenuDidShowNotification object:nil];
    [nc addObserver:self selector:@selector(handleSideMenuDidHideNotification:) name:AppDelegateSideMenuDidHideNotification object:nil];
    [nc addObserver:self selector:@selector(handleSideMenuDidTriggerShowNotification:) name:AppDelegateSideMenuDidTriggerShowNotification object:nil];
    [nc addObserver:self selector:@selector(handleSideMenuDidTriggerHideNotification:) name:AppDelegateSideMenuDidTriggerHideNotification object:nil];
}

- (void)handleSideMenuDidShowNotification:(NSNotification *)notification
{
    [self setOpen:YES];
}

- (void)handleSideMenuDidHideNotification:(NSNotification *)notification
{
    [self setOpen:NO];
}

- (void)handleSideMenuDidTriggerShowNotification:(NSNotification *)notification
{
    [self setOpen:YES];
}

- (void)handleSideMenuDidTriggerHideNotification:(NSNotification *)notification
{
    [self setOpen:NO];
}

@end
