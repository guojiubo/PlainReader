//
//  PRStackController.m
//  PlainReader
//
//  Created by guo on 11/8/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRStackController.h"

@interface PRStackController ()

@end

@implementation PRStackController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [self updateShadow];

    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(hanldeThemeChangedNotification:) name:PRAppSettingsThemeChangedNotification object:nil];
}

- (void)updateShadow
{
    self.view.backgroundColor = [UIColor pr_backgroundColor];
    
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    if ([settings isNightMode]) {
        self.shadowColor = [UIColor blackColor];
        self.shadowOffset = CGSizeMake(-2.0f, 0.0f);
        self.shadowOpacity = 0.2f;
        
        return;
    }
    
    self.shadowColor = [UIColor lightGrayColor];
    self.shadowOffset = CGSizeMake(-2.0f, 0.0f);
    self.shadowOpacity = 0.5f;
}

- (void)hanldeThemeChangedNotification:(NSNotification *)notification
{
    [self updateShadow];
}

@end
