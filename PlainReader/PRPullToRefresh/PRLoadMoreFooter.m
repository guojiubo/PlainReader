//
//  BLKLoadMoreFooterView.m
//  BLKTableViewController
//
//  Created by Black on 12-11-27.
//  Copyright (c) 2012年 com.gyz. All rights reserved.
//

#import "PRLoadMoreFooter.h"

@implementation PRLoadMoreFooter

+ (void)initialize
{
    if (self != [PRLoadMoreFooter class]) {
        return;
    }
    
    id appearence = [self appearance];
    [appearence setInfoColor:[UIColor lightGrayColor]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:14.0f];
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_infoLabel];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        _activityIndicator.hidesWhenStopped = YES;
        [self addSubview:_activityIndicator];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_infoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_infoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_infoLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-8]];
        
        self.state = PRLoadMoreStatePrompt;
    }
    return self;
}

- (void)setState:(PRLoadMoreState)state
{
    [_activityIndicator stopAnimating];
    
    switch (state) {
        case PRLoadMoreStatePrompt:
            [_infoLabel setText:NSLocalizedString(@"上拉加载更多", nil)];
            break;
        case PRLoadMoreStateLoading:
            [_infoLabel setText:NSLocalizedString(@"加载中...", nil)];
            [_activityIndicator startAnimating];
            break;
        case PRLoadMoreStateNoMore:
            [_infoLabel setText:NSLocalizedString(@"已加载完全部", nil)];
            break;
    }
    _state = state;
}

- (UIColor *)infoColor
{
    return [self.infoLabel textColor];
}

- (void)setInfoColor:(UIColor *)infoColor
{
    [self.infoLabel setTextColor:infoColor];
}

- (void)loadMoreFooterDidScroll:(UIScrollView *)scrollView
{
    if (self.state == PRLoadMoreStateLoading) {
        return;
    }
    if (self.state == PRLoadMoreStateNoMore) {
        return;
    }
    
    CGFloat offsetY = [scrollView contentOffset].y + [scrollView contentInset].top;
    if (offsetY <= 0) {
        return;
    }
    
    if ([scrollView contentOffset].y - [scrollView contentInset].bottom >= scrollView.contentSize.height - scrollView.bounds.size.height) {
        self.state = PRLoadMoreStateLoading;
        if (self.loadMoreTriggeredBlock) {
            self.loadMoreTriggeredBlock();
        }
    }
}

@end
