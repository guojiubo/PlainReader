//
//  PRAppearenceManager.m
//  PlainReader
//
//  Created by guo on 11/6/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRAppearanceManager.h"
#import "PRRefreshHeader.h"
#import "PRLoadMoreFooter.h"
#import "PRArticleCell.h"
#import "PRSectionHeader.h"
#import "PRHamburgerButton.h"
#import "PRTableView.h"
#import "PRTopCommentCell.h"
#import "PRSettingsViewController.h"
#import "UIColor+PRColors.h"

@implementation PRAppearanceManager

+ (instancetype)sharedManager
{
    static PRAppearanceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PRAppearanceManager alloc] init];
    });
    return manager;
}

- (void)setup
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserverForName:PRAppSettingsThemeChangedNotification object:[PRAppSettings sharedSettings] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [self updateAppearence:YES];
        }];
        
        [self updateAppearence:NO];
    });
}

- (void)updateAppearence:(BOOL)reload
{
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    if (settings.nightMode) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage cw_imageWithSolidColor:[UIColor pr_darkNavigationBarColor] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setBackgroundImage:[UIImage cw_imageWithSolidColor:[UIColor pr_backgroundColor] size:CGSizeMake(1, 1)] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIActivityIndicatorView appearance] setColor:[UIColor whiteColor]];
        [[UIActivityIndicatorView appearanceWhenContainedIn:[PRSettingsViewController class], nil] setColor:[UIColor lightGrayColor]];
        
        [[PRRefreshHeader appearance] setTitleColor:[UIColor whiteColor]];
        [[PRLoadMoreFooter appearance] setInfoColor:[UIColor whiteColor]];
        
        [[PRSectionHeader appearance] setTextColor:[UIColor whiteColor]];
        [[PRSectionHeader appearance] setBackgroundColor:[[UIColor pr_darkNavigationBarColor] colorWithAlphaComponent:0.95]];
        
        [[ArticleCellStarView appearance] setBackgroundColor:[[UIColor pr_darkNavigationBarColor] colorWithAlphaComponent:0.95]];
        
        [[PRHamburgerButton appearance] setHamburgerColor:[UIColor whiteColor]];
        
        
    }
    else {        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIActivityIndicatorView appearance] setColor:[UIColor lightGrayColor]];

        [[PRRefreshHeader appearance] setTitleColor:[UIColor pr_darkGrayColor]];
        [[PRLoadMoreFooter appearance] setInfoColor:[UIColor lightGrayColor]];
        
        [[PRSectionHeader appearance] setTextColor:[UIColor pr_darkGrayColor]];
        [[PRSectionHeader appearance] setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.95]];
        
        [[ArticleCellStarView appearance] setBackgroundColor:CW_HEXAColor(0xf0f0f0, 0.9)];
        
        [[PRHamburgerButton appearance] setHamburgerColor:[UIColor pr_blueColor]];
    }
    
    [[PRTableView appearance] setSeparatorColor:[UIColor pr_tableViewSeparatorColor]];
    [[PRTableView appearance] setBackgroundColor:[UIColor pr_backgroundColor]];
    
    if (!reload) {
        return;
    }
    
    // reload all views to apply appearance change
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

@end
