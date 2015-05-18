//
//  WeeklyViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-4-10.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRWeeklyViewController.h"
#import "PRArticleCell.h"
#import "PRArticleViewController.h"
#import "PRHTTPFetcher.h"
#import "PRSectionHeader.h"
#import "PRDatabase.h"
#import "PRAutoHamburgerButton.h"

@interface PRWeeklyViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PRWeeklyViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshHeader setTitle:@"本周热门"];
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    PRAutoHamburgerButton *menuButton = [PRAutoHamburgerButton button];
    [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setCenter:CGPointMake(CGRectGetWidth(menuView.bounds)/2, CGRectGetHeight(menuView.bounds)/2)];
    [menuView addSubview:menuButton];
    [self.refreshHeader setLeftView:menuView];

    self.dataSource = [[PRDatabase sharedDatabase] weekly];
    
    [self refreshTriggered];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleStarActionNotification:) name:ArticleViewControllerStarredNotification object:nil];
}

- (void)handleStarActionNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)menuButtonAction:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - PullRefresh

- (BOOL)useRefreshHeader
{
    return YES;
}

- (BOOL)useLoadMoreFooter
{
    return NO;
}

- (UIScrollView *)scrollView
{
    return self.tableView;
}

- (void)refreshTriggered
{
    [super refreshTriggered];
    
    [[PRHTTPFetcher fetcher] fetchWeekly:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self refreshCompleted];
        
        if (error) {
            [JDStatusBarNotification showError:[error cw_errorMessage]];
            return;
        }
        
        self.dataSource = [[PRDatabase sharedDatabase] weekly];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ArticleCell";
    PRArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PRArticleCell" owner:self options:nil] firstObject];
    }
    
    PRArticle *article = self.dataSource[indexPath.section][indexPath.row];
    cell.article = article;
    return cell;
}

#pragma mark - UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PRSectionHeader *header = [[PRSectionHeader alloc] init];
    [header setText:section == 0 ? @"热评资讯" : @"人气推荐"];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRArticle *article = self.dataSource[indexPath.section][indexPath.row];
    [article setRead:@YES];
    [[PRDatabase sharedDatabase] updateReadField:article];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    PRArticleViewController *vc = [PRArticleViewController cw_loadFromNibUsingClassName];
    vc.articleId = article.articleId;
    [self.stackController pushViewController:vc animated:YES];
}

@end
