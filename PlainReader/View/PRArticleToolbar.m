//
//  PRArticleToolbar.m
//  PlainReader
//
//  Created by guo on 5/17/15.
//  Copyright (c) 2015 GUOJIUBO. All rights reserved.
//

#import "PRArticleToolbar.h"

@implementation PRArticleToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self setup];
    return self;
}

- (void)setup
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 44.0f)];
    [backButton setImage:[UIImage imageNamed:@"navi_back_n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_p"] forState:UIControlStateHighlighted];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    _backButton = backButton;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 44)];
    [shareButton setImage:[UIImage imageNamed:@"article_share_n"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"article_share_p"] forState:UIControlStateHighlighted];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    _shareButton = shareButton;
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.center = CGPointMake(CGRectGetWidth(commentView.frame)/2, CGRectGetHeight(commentView.frame)/2);
    [commentView addSubview:activityIndicator];
    _activityIndicator = activityIndicator;

    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(0, 0, 60, 44);
    [commentButton setImage:[UIImage imageNamed:@"article_comment_n"] forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"article_comment_p"] forState:UIControlStateHighlighted];
    [commentButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    commentButton.imageEdgeInsets = UIEdgeInsetsMake(4, -5, 0, 0);
    [commentButton setTitleColor:[UIColor pr_lightGrayColor] forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor pr_blueColor] forState:UIControlStateHighlighted];
    [commentView addSubview:commentButton];
    _commentButton = commentButton;
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithCustomView:commentView];
    
    UIButton *starButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 44)];
    [starButton setImage:[UIImage imageNamed:@"ArticleUnstarred"] forState:UIControlStateNormal];
    [starButton setImage:[UIImage imageNamed:@"ArticleStarred"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [starButton setImage:[UIImage imageNamed:@"ArticleStarred"] forState:UIControlStateSelected];
    UIBarButtonItem *starItem = [[UIBarButtonItem alloc] initWithCustomView:starButton];
    _starButton = starButton;
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = -16;
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setItems:@[fixedItem, backItem, flexibleItem, starItem, flexibleItem, shareItem, flexibleItem, commentItem, fixedItem]];
}

- (void)startLoading
{
    self.commentButton.hidden = YES;
    [self.activityIndicator startAnimating];
}

- (void)stopLoading
{
    self.commentButton.hidden = NO;
    [self.activityIndicator stopAnimating];
}

@end
