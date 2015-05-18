//
//  TopCommentsViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-5-11.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRTopCommentsViewController.h"
#import "PRHTTPFetcher.h"
#import "PRTopCommentCell.h"
#import "PRArticleViewController.h"
#import "PRTopComment.h"
#import "PRDatabase.h"
#import "PRAutoHamburgerButton.h"

@interface PRTopCommentsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, assign) NSUInteger page;

@end

@implementation PRTopCommentsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    PRAutoHamburgerButton *menuButton = [PRAutoHamburgerButton button];
    [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setCenter:CGPointMake(CGRectGetWidth(menuView.bounds)/2, CGRectGetHeight(menuView.bounds)/2)];
    [menuView addSubview:menuButton];
    [self.refreshHeader setLeftView:menuView];
    
    [self.refreshHeader setTitle:@"精彩评论"];
    
    UIEdgeInsets contentInsets = [[self scrollView] contentInset];
    contentInsets.bottom = CGRectGetHeight([[self.tabBarController tabBar] frame]);
    [[self scrollView] setContentInset:contentInsets];
    [[self scrollView] setScrollIndicatorInsets:contentInsets];
    
    self.comments = [NSMutableArray arrayWithArray:[[PRDatabase sharedDatabase] topCommentsWithLastTopComment:nil limit:24]];
    
    [self refreshTriggered];
}

- (void)menuButtonAction:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (UIScrollView *)scrollView
{
    return self.tableView;
}

- (void)refreshTriggered
{
    [super refreshTriggered];
    
    self.page = 1;
    
    PRHTTPFetcher *fetcher = [PRHTTPFetcher fetcher];
    [fetcher fetchTopCommentsWithPage:self.page done:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self refreshCompleted];
        
        if (error) {
            [JDStatusBarNotification showError:[error cw_errorMessage]];
            return;
        }
        
        self.comments = [NSMutableArray arrayWithArray:[[PRDatabase sharedDatabase] topCommentsWithLastTopComment:nil limit:10]];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreTriggered
{
    [super loadMoreTriggered];
    
    NSUInteger page = self.page;
    PRHTTPFetcher *fetcher = [PRHTTPFetcher fetcher];
    [fetcher fetchTopCommentsWithPage:page+1 done:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self loadMoreCompletedWithNoMore:NO];
        
        if (!fetcher.error) {
            self.page++;
        }
        
        PRTopComment *lastTopComment = [self.comments lastObject];
        [self.comments addObjectsFromArray:[[PRDatabase sharedDatabase] topCommentsWithLastTopComment:lastTopComment limit:10]];

        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ? @"TopCommentCell" : @"TopCommentCellPad";
    PRTopCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    PRTopComment *comment = self.comments[indexPath.row];
    [cell configureForTableView:tableView dataObject:comment indexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRTopComment *comment = self.comments[indexPath.row];
    return [PRTopCommentCell cellHeightForTableView:tableView dataObject:comment];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PRArticleViewController *vc = [PRArticleViewController cw_loadFromNibUsingClassName];
    vc.articleId = [[self.comments[indexPath.row] article] articleId];
    [self.stackController pushViewController:vc animated:YES];
}

@end
