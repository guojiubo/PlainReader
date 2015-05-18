//
//  WebViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-5-22.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRBrowserViewController.h"

@interface PRBrowserViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *forwardButton;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation PRBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    
    UIEdgeInsets insets = [[self.webView scrollView] contentInset];
    insets.bottom = insets.bottom + 44;
    [[self.webView scrollView] setContentInset:insets];
    [[self.webView scrollView] setScrollIndicatorInsets:[[self.webView scrollView] contentInset]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 56.0f, 44.0f)];
    [backButton setImage:[UIImage imageNamed:@"navi_back_n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_p"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshHeader setLeftView:backButton];
    
    [self.backButton setEnabled:NO];
    [self.forwardButton setEnabled:NO];
    [self.refreshButton setHidden:YES];
    [self.indicator startAnimating];
    
    [self.webView loadRequest:self.request];
    
    [self.stackController setContentScrollView:[self.webView scrollView]];
}

- (void)backAction:(id)sender
{
    [self.stackController popViewControllerAnimated:YES];
}

#pragma mark - PullRefresh

- (UIScrollView *)scrollView
{
    return [self.webView scrollView];
}

- (BOOL)useLoadMoreFooter
{
    return NO;
}

- (BOOL)useRefreshHeader
{
    return NO;
}

#pragma mark - browser

- (IBAction)goBack:(id)sender
{
    if (![self.webView canGoBack]) {
        return;
    }
    
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender
{
    if (![self.webView canGoForward]) {
        return;
    }
    
    [self.webView goForward];
}

- (IBAction)openInSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:[self.request URL]];
}

- (IBAction)refresh:(id)sender
{
    [self.webView reload];
}

- (void)refreshButtonState
{
    [self.backButton setEnabled:[self.webView canGoBack]];
    [self.forwardButton setEnabled:[self.webView canGoForward]];
}

#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self refreshButtonState];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self refreshButtonState];
    [self.refreshButton setHidden:YES];
    [self.indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self refreshButtonState];
    [self.refreshButton setHidden:NO];
    [self.indicator stopAnimating];
    
    [self.refreshHeader setTitle:webView.cw_documentTitle];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self refreshButtonState];
    [self.refreshButton setHidden:NO];
    [self.indicator stopAnimating];
}

@end
