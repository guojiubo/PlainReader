//
//  CommentPostViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-5-20.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRCommentPostViewController.h"
#import "PRRefreshHeader.h"
#import "PRHTTPFetcher.h"
#import "PREmoticonView.h"

@interface PRCommentPostViewController ()

@property (nonatomic, weak) IBOutlet PRRefreshHeader *refreshHeader;
@property (nonatomic, weak) IBOutlet CWPlaceholderTextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, weak) IBOutlet UIButton *emoticonButton;
@property (nonatomic, weak) IBOutlet UIButton *keyboardButton;
@property (nonatomic, strong) PREmoticonView *emoticonView;
@property (nonatomic, weak) IBOutlet UIImageView *contentBorder;
@property (nonatomic, weak) IBOutlet UIImageView *codeBorder;

@end

@implementation PRCommentPostViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.contentBorder layer] setBorderWidth:0.5];

    PRAppSettings *settings = [PRAppSettings sharedSettings];
    if ([settings isNightMode]) {
        self.contentBorder.backgroundColor = [UIColor pr_darkNavigationBarColor];
        [self.contentBorder.layer setBorderColor:[UIColor pr_tableViewSeparatorColor].CGColor];
        [self.textView setTextColor:[UIColor whiteColor]];
        [self.textView setPlaceholderTextColor:[UIColor pr_lightGrayColor]];
        [self.textField setTextColor:[UIColor whiteColor]];
        [self.textField cw_setPlaceholder:@"输入验证码" color:[UIColor pr_lightGrayColor]];
    }
    else {
        [self.contentBorder.layer setBorderColor:CW_HEXColor(0xe0e0e0).CGColor];
        self.contentBorder.backgroundColor = CW_HEXColor(0xf3f3f3);
    }
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 56.0f, 44.0f)];
    [backButton setImage:[UIImage imageNamed:@"navi_back_n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_p"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshHeader setLeftView:backButton];
    
    [self stopLoading];
    
    if (self.comment) {
        [self.refreshHeader setTitle:@"回复评论"];
        [self.textView setPlaceholder:[NSString stringWithFormat:@"回复评论:%@", [self.comment content]]];
    }
    else {
        [self.refreshHeader setTitle:@"发表评论"];
        [self.textView setPlaceholder:@"输入评论内容"];
    }
    
    [self refetchSecurityCode:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (IBAction)refetchSecurityCode:(id)sender
{
    [self.button setTitle:@"" forState:UIControlStateNormal];
    [self.button setBackgroundImage:nil forState:UIControlStateNormal];
    
    if ([self.indicator isAnimating]) {
        return;
    }
    
    [self.indicator startAnimating];
    [[PRHTTPFetcher fetcher] fetchSecurityCodeForArticle:self.article done:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self.indicator stopAnimating];
        if (error) {
            [JDStatusBarNotification showError:@"验证码获取失败"];
            [self.button setTitle:@"重新获取" forState:UIControlStateNormal];
            [self.button setBackgroundImage:nil forState:UIControlStateNormal];
            return;
        }
        
        [self.button setTitle:@"" forState:UIControlStateNormal];
        [self.button setBackgroundImage:fetcher.responseObject forState:UIControlStateNormal];
    }];
}

- (IBAction)emoticonAction:(id)sender
{
    [self.emoticonButton setHidden:YES];
    [self.keyboardButton setHidden:NO];
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    
    if (!self.emoticonView) {
        PREmoticonView *view = [[PREmoticonView alloc] initWithFrame:CGRectMake(0, 0, [self.view cw_width], 216)];
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [view setEmoticonSelectionBlock:^(NSString *emoticon) {
            NSString *text = [self.textView text];
            text = [text stringByAppendingString:emoticon];
            [self.textView setText:text];
        }];
        [view setEmoticonDeletionBlock:^{
            NSString *text = [self.textView text];
            if ([text length] == 0) {
                return;
            }
            text = [text substringToIndex:text.length - 1];
            [self.textView setText:text];
        }];
        self.emoticonView = view;
    }
    
    [self.emoticonView cw_setTop:[self.view cw_height]];
    [self.view addSubview:self.emoticonView];
    [UIView animateWithDuration:.25 animations:^{
        [self.emoticonView cw_setBottom:[self.view cw_height]];
    }];
}

- (IBAction)keyboardAction:(id)sender
{
    [self.emoticonButton setHidden:NO];
    [self.keyboardButton setHidden:YES];
    
    [UIView animateWithDuration:.25 animations:^{
        [self.emoticonView cw_setTop:[self.view cw_height]];
    } completion:^(BOOL finished) {
        [self.emoticonView removeFromSuperview];
        [self.textView becomeFirstResponder];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.emoticonButton setHidden:NO];
    [self.keyboardButton setHidden:YES];
    
    [UIView animateWithDuration:.25 animations:^{
        [self.emoticonView cw_setTop:[[UIScreen mainScreen] bounds].size.height];
    } completion:^(BOOL finished) {
        [self.emoticonView removeFromSuperview];
    }];
}

#pragma mark - FSStack

- (void)backAction:(id)sender
{
    [self.stackController popViewControllerAnimated:YES];
}

- (UIViewController *)nextViewController
{
    return nil;
}

- (void)showLoading
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 44)];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    indicator.center = CGPointMake(28, 22);
    [view addSubview:indicator];
    [self.refreshHeader setRightView:view];
}

- (void)stopLoading
{
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(0, 0, 56, 44);
    [postButton setImage:[UIImage imageNamed:@"comment_post_n"] forState:UIControlStateNormal];
    [postButton setImage:[UIImage imageNamed:@"comment_post_p"] forState:UIControlStateHighlighted];
    [postButton addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshHeader setRightView:postButton];
}

- (void)post:(id)sender
{
    NSString *content = [[self.textView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([content length] == 0) {
        NSString *message = @"请输入评论";
        [JDStatusBarNotification showError:message];
        return;
    }
    
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    
    if ([[PRAppSettings sharedSettings] autoStarCommented]) {
        [[PRDatabase sharedDatabase] starArticle:self.article];
        [JDStatusBarNotification showSuccess:@"文章已自动收藏"];
    }
    
    [self showLoading];
    
    if (self.comment) {
        [[PRHTTPFetcher fetcher] replyComment:self.comment content:content securityCode:[self.textField text] done:^(CWHTTPFetcher *fetcher, NSError *error) {
            [self stopLoading];
            
            if (error) {
                [self refetchSecurityCode:nil];
                [JDStatusBarNotification showError:[fetcher.error cw_errorMessage]];
                return;
            }
            
            [JDStatusBarNotification showSuccess:@"发表成功! 请耐心等待小编审核"];
            [self.stackController popViewControllerAnimated:YES];
        }];
        return;
    }
    
    [[PRHTTPFetcher fetcher] postCommentToArticle:self.article content:content securityCode:[self.textField text] done:^(CWHTTPFetcher *fetcher, NSError *error) {
        [self stopLoading];
        
        if (error) {
            [self refetchSecurityCode:nil];
            [JDStatusBarNotification showError:[fetcher.error cw_errorMessage]];
            return;
        }
        
        [JDStatusBarNotification showSuccess:@"发表成功! 请耐心等待小编审核"];
        [self.stackController popViewControllerAnimated:YES];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self post:nil];
    
    return YES;
}

@end
