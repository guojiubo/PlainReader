//
//  PRViewController.m
//  PlainReader
//
//  Created by guo on 11/28/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRViewController.h"

@interface PRViewController ()

@end

@implementation PRViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateTheme];
    
    [self updateTheme];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleThemeChangedNotification:) name:PRAppSettingsThemeChangedNotification object:nil];
}

- (void)updateTheme
{
    self.view.backgroundColor = [UIColor pr_backgroundColor];
}

- (void)handleThemeChangedNotification:(NSNotification *)notification
{
    [self updateTheme];
}

@end
