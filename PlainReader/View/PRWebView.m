//
//  PRWebView.m
//  PlainReader
//
//  Created by guo on 11/1/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRWebView.h"

@implementation PRWebView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.opaque = NO;

    [self updateDisplay];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleThemeChangedNotification:) name:PRAppSettingsThemeChangedNotification object:nil];
}

- (void)updateDisplay
{
    self.backgroundColor = [UIColor pr_backgroundColor];
}

- (void)handleThemeChangedNotification:(NSNotification *)notification
{
    [self updateDisplay];
}

@end
