//
//  CommentsViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-4-6.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRCommentsViewController.h"
#import "PRHTTPFetcher.h"
#import "PRComment.h"
#import "PRCommentPostViewController.h"
#import "PRSectionHeader.h"
#import "PRCommentCell.h"

@interface PRCommentsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PRHTTPFetcher *commentsFetcher;

@end

@implementation PRCommentsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshHeader setTitle:@"评论"];
        
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 56.0f, 44.0f)];
    [backButton setImage:[UIImage imageNamed:@"navi_back_n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_p"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshHeader setLeftView:backButton];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(0, 0, 56, 44);
    [postButton setImage:[UIImage imageNamed:@"comment_edit_n"] forState:UIControlStateNormal];
    [postButton setImage:[UIImage imageNamed:@"comment_edit_p"] forState:UIControlStateHighlighted];
    [postButton addTarget:self action:@selector(postComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshHeader setRightView:postButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommentsFetchedNotification:) name:PRHTTPFetcherDidFetchCommentsNotification object:nil];
    
    UIView *fakeFooter = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:fakeFooter];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)handleCommentsFetchedNotification:(NSNotification *)notification
{
    self.comments = [notification cw_userObject];
    [self.tableView reloadData];
}

#pragma mark - PullRefresh

- (UIScrollView *)scrollView
{
    return self.tableView;
}

- (BOOL)useLoadMoreFooter
{
    return NO;
}

- (void)refreshTriggered
{
    [super refreshTriggered];
    
    self.commentsFetcher = [PRHTTPFetcher fetcher];
    [self.commentsFetcher fetchCommentsOfArticle:self.article done:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self refreshCompleted];
        
        if (error) {
            [JDStatusBarNotification showError:[error cw_errorMessage]];
        }
    }];
}

- (void)postComment:(id)sender
{
    PRCommentPostViewController *vc = [[PRCommentPostViewController alloc] init];
    vc.article = self.article;
    [self.stackController pushViewController:vc animated:YES];
}

#pragma mark - Vote

- (void)support:(PRCellButton *)button
{
    PRComment *comment = button.userInfo;
    
    if (comment.supported) {
        return;
    }
    
    comment.support++;
    comment.supported = YES;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self vote:comment support:YES];
}

- (void)oppose:(PRCellButton *)button
{
    PRComment *comment = button.userInfo;
    
    if (comment.opposed) {
        return;
    }
    
    comment.oppose++;
    comment.opposed = YES;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self vote:comment support:NO];
}

- (void)vote:(PRComment *)comment support:(BOOL)support
{
    PRHTTPFetcher *fetcher = [PRHTTPFetcher fetcher];
    [fetcher vote:comment support:support done:^(CWHTTPFetcher *fetcher, NSError *error) {
        [JDStatusBarNotification showSuccess:support ? @"支持++" : @"反对++"];
    }];
}

- (void)reply:(PRCellButton *)button
{
    PRComment *comment = button.userInfo;
    PRCommentPostViewController *vc = [[PRCommentPostViewController alloc] init];
    vc.article = self.article;
    vc.comment = comment;
    [self.stackController pushViewController:vc animated:YES];
}

#pragma mark - FSStack

- (void)backAction:(id)sender
{
    [self.stackController popViewControllerAnimated:YES];
}

- (UIViewController *)nextViewController
{
    PRCommentPostViewController *vc = [[PRCommentPostViewController alloc] init];
    vc.article = self.article;
    return vc;
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.comments count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRComment *comment = self.comments[indexPath.section][indexPath.row];
    
    NSString *identifier = [PRCommentCell reuseIdentifierForComment:comment];
    
    PRCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PRCommentCell alloc] initWithComment:comment];
    }
    
    [cell configureWithComment:comment tableView:tableView indexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRComment *comment = self.comments[indexPath.section][indexPath.row];
    return [PRCommentCell cellHeightForComment:comment inTableView:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSUInteger count = [self.comments count];
    if (count == 0) {
        return nil;
    }
    
    PRSectionHeader *header = [[PRSectionHeader alloc] initWithFrame:CGRectMake(0, 0, [tableView frame].size.width, 26)];
    if (count != 2) {
        [header setText:@"所有评论"];
    }
    else {
        if (section == 0) {
            [header setText:@"热门评论"];
        }
        else {
            [header setText:@"所有评论"];
        }
    }
    
    return header;
}

@end
