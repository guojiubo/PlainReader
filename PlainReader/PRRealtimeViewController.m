//
//  RealtimeNewsViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-3-23.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRRealtimeViewController.h"
#import "PRHTTPFetcher.h"
#import "PRArticleViewController.h"
#import "PRArticleCell.h"
#import "PRDatabase.h"
#import "PRAutoHamburgerButton.h"
#import "PRSectionHeader.h"

static const NSUInteger kPageSize = 40;

@interface PRRealtimeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableDictionary *sectionDict;

@end

@implementation PRRealtimeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshHeader setTitle:@"实时资讯"];
        
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    PRAutoHamburgerButton *menuButton = [PRAutoHamburgerButton button];
    [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setCenter:CGPointMake(CGRectGetWidth(menuView.bounds)/2, CGRectGetHeight(menuView.bounds)/2)];
    [menuView addSubview:menuButton];
    [self.refreshHeader setLeftView:menuView];
    
    self.sectionTitles = [[NSMutableArray alloc] init];
    self.sectionDict = [[NSMutableDictionary alloc] init];
    
    NSArray *articles = [[PRDatabase sharedDatabase] realtimesWithLastArticle:nil limit:kPageSize];
    [self arrangeArticles:articles];
    
    [self refreshTriggered];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleStarActionNotification:) name:ArticleViewControllerStarredNotification object:nil];
}

- (void)handleStarActionNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)arrangeArticles:(NSArray *)articles
{
    // pubTime format: yyyy-MM-dd HH:mm:ss, we only need its date
    for (PRArticle *article in articles) {
        if ([article.pubTime length] < 10) {
            continue;
        }
        
        NSString *title = [article.pubTime substringToIndex:10];
        if (![self.sectionTitles cw_containsString:title]) {
            [self.sectionTitles addObject:title];
        }
        
        NSMutableArray *sections = self.sectionDict[title];
        if (!sections) {
            sections = [[NSMutableArray alloc] init];
            self.sectionDict[title] = sections;
        }
        [sections addObject:article];
    }
}

- (void)menuButtonAction:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - Pull To Refresh

- (UIScrollView *)scrollView
{
    return self.tableView;
}

- (void)refreshTriggered
{
    [super refreshTriggered];
    
    // Reset page
    self.page = 2;
    
    [[PRHTTPFetcher fetcher] fetchHomePage:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self loadMoreCompletedWithNoMore:NO];
        [self refreshCompleted];
        
        if (error) {
            [JDStatusBarNotification showError:[error cw_errorMessage]];
            return;
        }
        
        NSArray *articles = [[PRDatabase sharedDatabase] realtimesWithLastArticle:nil limit:kPageSize];
        [self.sectionDict removeAllObjects];
        [self.sectionTitles removeAllObjects];
        [self arrangeArticles:articles];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreTriggered
{
    [super loadMoreTriggered];
    
    PRHTTPFetcher *fetcher = [PRHTTPFetcher fetcher];
    [fetcher fetchRealtimeWithPage:self.page done:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self loadMoreCompletedWithNoMore:NO];
        
        if (!fetcher.error) {
            self.page++;
        }
        
        if (fetcher.error && fetcher.error.code == NSURLErrorTimedOut) {
            [JDStatusBarNotification showError:fetcher.error.localizedDescription];
        }
        else {
            NSString *lastSectionTitle = [self.sectionTitles lastObject];
            PRArticle *lastArticle = [self.sectionDict[lastSectionTitle] lastObject];
            NSArray *articles = [[PRDatabase sharedDatabase] realtimesWithLastArticle:lastArticle limit:kPageSize];
            [self arrangeArticles:articles];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *titleKey = self.sectionTitles[section];
    return [self.sectionDict[titleKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ArticleCell";
    PRArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PRArticleCell" owner:self options:nil] firstObject];
    }
    
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    PRArticle *article = self.sectionDict[sectionTitle][indexPath.row];
    cell.article = article;
    return cell;
}

#pragma mark - UITableView delegate

static NSDateFormatter *sectionDateFormatter = nil;
static NSDateFormatter *weekdayFormatter = nil;
static NSDateFormatter *sectionTitleFormatter = nil;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!sectionDateFormatter) {
        sectionDateFormatter = [[NSDateFormatter alloc] init];
        [sectionDateFormatter setDateFormat:@"yyyy-MM-dd"];
        weekdayFormatter = [[NSDateFormatter alloc] init];
        [weekdayFormatter setDateFormat:@"e"];
        sectionTitleFormatter = [[NSDateFormatter alloc] init];
        [sectionTitleFormatter setDateFormat:@"MM月dd日"];
    }

    PRSectionHeader *header = [[PRSectionHeader alloc] init];
    NSString *sectionTitle = self.sectionTitles[section];
    
    NSDate *sectionDate = [sectionDateFormatter dateFromString:sectionTitle];
    NSInteger weekday = [[weekdayFormatter stringFromDate:sectionDate] integerValue];
    NSString *date = [sectionTitleFormatter stringFromDate:sectionDate];
    
    NSAssert(weekday >= 1 && weekday <= 7, @"Invalid weekday!");
    weekday = MIN(7, MAX(weekday, 1));
    
    NSArray *weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    [header setText:[NSString stringWithFormat:@"%@ %@", date, weekdays[weekday - 1]]];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    PRArticle *article = self.sectionDict[sectionTitle][indexPath.row];
    [article setRead:@YES];
    [[PRDatabase sharedDatabase] updateReadField:article];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    PRArticleViewController *vc = [PRArticleViewController cw_loadFromNibUsingClassName];
    vc.articleId = article.articleId;
    [self.stackController pushViewController:vc animated:YES];
}

@end
