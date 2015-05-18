//
//  ArticleViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-3-25.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRArticleViewController.h"
#import "PRHTTPFetcher.h"
#import "PRRefreshHeader.h"
#import "PRCommentsViewController.h"
#import "PRBrowserViewController.h"
#import "PRDatabase.h"
#import "CWObjectCache.h"
#import "PRCachedURLResponse.h"
#import "PRWebView.h"
#import "JTSImageViewController.h"
#import "PRArticleParser.h"
#import "PRArticleToolbar.h"

NSString *const ArticleViewControllerStarredNotification = @"ArticleViewControllerStarredNotification";
static CGFloat kStatusBarHeight = 20.0f;
static CGFloat kToolbarHeight = 44.0f;

@interface PRArticleViewController () <UIScrollViewDelegate, UINavigationControllerDelegate, JTSImageViewControllerInteractionsDelegate>

@property (nonatomic, strong) PRArticle *article;
@property (nonatomic, weak) IBOutlet UIView *statusBarBackground;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet PRArticleToolbar *toolbar;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *statusBarTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;
@property (nonatomic, strong) PRHTTPFetcher *articleFetcher;
@property (nonatomic, strong) PRHTTPFetcher *commentsFetcher;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, assign) CGPoint lastContentOffset;

@end

@implementation PRArticleViewController

- (void)dealloc
{
    [[self.webView scrollView] cw_setFooterView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.articleFetcher cancel];
    [self.commentsFetcher cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.statusBarBackground.backgroundColor = [UIColor pr_backgroundColor];
    
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    if (settings.articleFastScroll) {
        [[self.webView scrollView] setDecelerationRate:UIScrollViewDecelerationRateNormal];
    }
    else {
        [[self.webView scrollView] setDecelerationRate:UIScrollViewDecelerationRateFast];
    }
    
    [[self.webView scrollView] setDelegate:self];

    UIEdgeInsets insets = [[self.webView scrollView] contentInset];
    insets.top = kStatusBarHeight;
    insets.bottom = kToolbarHeight;
    [[self.webView scrollView] setContentInset:insets];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.webView.scrollView.scrollIndicatorInsets = insets;
    }
    
    [self.toolbar.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.starButton addTarget:self action:@selector(starAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];

    PRHTTPFetcher *fetcher = [PRHTTPFetcher fetcher];
    self.articleFetcher = fetcher;
    [fetcher fetchArticle:self.articleId useCache:YES done:^(CWHTTPFetcher *fetcher, NSError *error) {
        self.article = fetcher.responseObject;
        [self.toolbar.starButton setSelected:[self.article isStarred]];

        if (error) {
            [self.toolbar stopLoading];
            return;
        }
        
        [self.webView loadHTMLString:[self.article toHTML] baseURL:[[NSBundle mainBundle] bundleURL]];
        [self fetchComments];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.toolbar.starButton setSelected:[self.article isStarred]];
    
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
        self.statusBarTopConstraint.constant = -kStatusBarHeight;
    }
    else {
        self.statusBarTopConstraint.constant = 0;
    }
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)fetchComments
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCommentsFetchedNotification:)
                                                 name:PRHTTPFetcherDidFetchCommentsNotification
                                               object:nil];
    
    [self.toolbar startLoading];
    
    self.commentsFetcher = [PRHTTPFetcher fetcher];
    [self.commentsFetcher fetchCommentsOfArticle:self.article done:^(CWHTTPFetcher *fetcher, NSError *error) {
    }];
}

- (void)handleCommentsFetchedNotification:(NSNotification *)notification
{
    self.comments = [notification cw_userObject];
    NSInteger commentCount = [[self.comments lastObject] count];
    [self.article setCommentCount:@(commentCount)];
    [[PRDatabase sharedDatabase] storeArticle:self.article];
    
    [self.toolbar.commentButton setTitle:[@(commentCount) stringValue] forState:UIControlStateNormal];
    [self.toolbar stopLoading];
}

#pragma mark - Actions

- (void)backAction:(id)sender
{
    [self.stackController popViewControllerAnimated:YES];
}

- (void)starAction:(UIButton *)sender
{
    if (!sender.isSelected) {
        [[PRDatabase sharedDatabase] starArticle:self.article];
    }
    else {
        [[PRDatabase sharedDatabase] unstarArticle:self.article];
    }
    
    sender.selected = !sender.isSelected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ArticleViewControllerStarredNotification object:nil];
}

- (void)commentAction:(id)sender
{
    [self.stackController pushViewController:[self nextViewController] animated:YES];
}

- (void)shareAction:(id)sender
{
    UIImage *image = [self queryCachedImageForKey:[[self.article imgSrcs] firstObject]];
    if (!image) {
        image = [UIImage imageNamed:@"AppIcon60x60"];
    }

    NSString *url = [NSString stringWithFormat:@"http://www.cnbeta.com/articles/%@.htm", [self.article articleId]];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[self.article.title, image, url] applicationActivities:nil];
    [self.stackController presentViewController:avc animated:YES completion:nil];
    
    if ([avc respondsToSelector:@selector(popoverPresentationController)]) {
        // iOS 8+
        UIPopoverPresentationController *presentationController = [avc popoverPresentationController];
        presentationController.sourceView = sender;
    }
}

#pragma mark - Helper

- (UIImage *)queryCachedImageForKey:(NSString *)key
{
    PRCachedURLResponse *cache = [[CWObjectCache sharedCache] objectForKey:key];
    if (cache && [cache isKindOfClass:[PRCachedURLResponse class]]) {
        if (cache.data) {
            return [[UIImage alloc] initWithData:cache.data];
        }
    }
    return nil;
}

#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        return YES;
    }
    
    if ([request.URL.scheme isEqualToString:@"plainreader"]) {
        NSString *query = request.URL.query;
        UIImage *image = [self queryCachedImageForKey:query];
        if (!image) {
            return NO;
        }
        
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = image;
        
        JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                               initWithImageInfo:imageInfo
                                               mode:JTSImageViewControllerMode_Image
                                               backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
        [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
        return NO;
    }
    
    PRBrowserViewController *vc = [[PRBrowserViewController alloc] init];
    vc.request = request;
    [self.stackController pushViewController:vc animated:YES];
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    
    CGFloat distance = scrollView.contentOffset.y - self.lastContentOffset.y;
    if (distance > 0 && scrollView.contentOffset.y > 0) {
        // pull up
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
        self.statusBarTopConstraint.constant = -kStatusBarHeight;
        self.toolbarBottomConstraint.constant = -kToolbarHeight;
        [UIView animateWithDuration:0.3 animations:^{
            UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
            insets.top = 0;
            insets.bottom = 0;
            scrollView.scrollIndicatorInsets = insets;
            [self.view layoutIfNeeded];
        }];
    }
    else {
        // pull down
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
        self.statusBarTopConstraint.constant = 0;
        self.toolbarBottomConstraint.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
            insets.top = kStatusBarHeight;
            insets.bottom = kToolbarHeight;
            scrollView.scrollIndicatorInsets = insets;
            [self.view layoutIfNeeded];
        }];
    }
    
    self.lastContentOffset = scrollView.contentOffset;
}

#pragma mark - CWStack

- (UIViewController *)nextViewController
{
    if ([self.toolbar.activityIndicator isAnimating]) {
        return nil;
    }
    
    PRCommentsViewController *vc = [PRCommentsViewController cw_loadFromNibUsingClassName];
    vc.article = self.article;
    vc.comments = self.comments;
    return vc;
}

@end
