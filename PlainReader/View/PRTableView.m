//
//  PRAppearanceTableView.m
//  PlainReader
//
//  Created by guojiubo on 11/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRTableView.h"
#import "PRArticleViewController.h"

@implementation PRTableView

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
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleThemeChangedNotification:) name:PRAppSettingsThemeChangedNotification object:nil];
}

- (void)handleThemeChangedNotification:(NSNotification *)notification
{
    [self reloadData];
}

@end
