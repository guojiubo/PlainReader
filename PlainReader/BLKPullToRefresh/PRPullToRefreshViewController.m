//
//  BLKPullToRefreshViewController.m
//  BLKPullToRefresh
//
//  Created by guojiubo on 14-3-19.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRPullToRefreshViewController.h"

@interface PRPullToRefreshViewController ()

@property (nonatomic, strong) PRRefreshHeader *refreshHeader;
@property (nonatomic, strong) PRLoadMoreFooter *loadMoreFooter;

@end

@implementation PRPullToRefreshViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert([self scrollView], NSLocalizedString(@"Need to setup scrollView before calling [super viewDidLoad]", nil));
    
    UIEdgeInsets contentInsets = [[self scrollView] contentInset];
    contentInsets.top += 64.0f;
    
    [[self scrollView] setContentInset:contentInsets];
    [[self scrollView] setScrollIndicatorInsets:contentInsets];
    
    PRRefreshHeader *refreshHeader = [[PRRefreshHeader alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    refreshHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:refreshHeader];
    self.refreshHeader = refreshHeader;
    
    if ([self useRefreshHeader]) {
        __weak PRPullToRefreshViewController *welf = self;
        [self.refreshHeader setRefreshTriggeredBlock:^{
            [welf refreshTriggered];
        }];
    }
    
    if ([self useLoadMoreFooter]) {
        self.loadMoreFooter = [[PRLoadMoreFooter alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([self scrollView].bounds), 44.0f)];
        if ([[self scrollView] isKindOfClass:[UITableView class]]) {
            [(UITableView *)[self scrollView] setTableFooterView:self.loadMoreFooter];
        }
        else {
            [[self scrollView] cw_setFooterView:self.loadMoreFooter];
        }
        
        __weak PRPullToRefreshViewController *weakSelf = self;
        [self.loadMoreFooter setLoadMoreTriggeredBlock:^{
            [weakSelf loadMoreTriggered];
        }];
    }
}

- (UIScrollView *)scrollView
{
    return nil;
}

#pragma mark - Refresh

- (BOOL)useRefreshHeader
{
    return YES;
}

- (void)refreshTriggered
{
    [self.refreshHeader setState:PRRefreshStateRefreshing];
}

- (void)refreshCompleted
{
    [self.refreshHeader restore];
}

#pragma mark - Load more

- (BOOL)useLoadMoreFooter
{
    return YES;
}

- (void)loadMoreTriggered
{
    
}

- (void)loadMoreCompletedWithNoMore:(BOOL)isNoMore
{
    [self.loadMoreFooter setState:isNoMore ? PRLoadMoreStateNoMore : PRLoadMoreStatePrompt];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![self useRefreshHeader] && ![self useLoadMoreFooter]) {
        return;
    }
    
    [self.refreshHeader pullToRefreshHeaderDidScroll:scrollView];
    [self.loadMoreFooter loadMoreFooterDidScroll:scrollView];
}

@end
