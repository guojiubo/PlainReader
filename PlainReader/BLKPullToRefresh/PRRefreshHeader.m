//
//  BLKPullToRefreshHeader.m
//  BLKPullToRefresh
//
//  Created by guojiubo on 14-3-19.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRRefreshHeader.h"

@interface PRRefreshHeader ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelBottomContstraint;

@end

@implementation PRRefreshHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    UINavigationBar *bar = [[UINavigationBar alloc] init];
    bar.translucent = NO;
    [self addSubview:bar];
    
    bar.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(bar);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bar]|" options:0 metrics:nil views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bar(1000)]|" options:0 metrics:nil views:viewDict]];
        
    UIView *titleView = [[UIView alloc] init];
    [self addSubview:titleView];
    
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    viewDict = NSDictionaryOfVariableBindings(titleView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleView]|" options:0 metrics:nil views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleView(44)]|" options:0 metrics:nil views:viewDict]];
    
    _titleLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(50.0f, 0.0f, CGRectGetWidth(frame) - 100.0f, 44.0f)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor pr_darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:19.0f];
    [titleView addSubview:_titleLabel];
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    viewDict = NSDictionaryOfVariableBindings(_titleLabel);
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(44)-[_titleLabel]-(44)-|" options:0 metrics:nil views:viewDict]];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:44];
    [titleView addConstraint:height];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [titleView addConstraint:bottom];
    self.titleLabelBottomContstraint = bottom;
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.textColor = [UIColor darkGrayColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:13.0f];
    _subtitleLabel.alpha = 0.0f;
    [titleView addSubview:_subtitleLabel];
    
    _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    viewDict = NSDictionaryOfVariableBindings(_subtitleLabel);
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_subtitleLabel]|" options:0 metrics:nil views:viewDict]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subtitleLabel(22)]|" options:0 metrics:nil views:viewDict]];
    
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RefreshHeaderLogo"]];
    [_logo setAlpha:0.0f];
    [self addSubview:_logo];
    
    _logo.translatesAutoresizingMaskIntoConstraints = NO;
    viewDict = NSDictionaryOfVariableBindings(_logo);
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_logo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_logo]-(44)-|" options:0 metrics:nil views:viewDict]];
    
    [self setState:PRRefreshStatePulling];
}

- (void)setState:(PRRefreshState)state
{
    switch (state) {
        case PRRefreshStatePulling:
            [self.subtitleLabel setText:NSLocalizedString(@"下拉刷新", nil)];
            break;
        case PRRefreshStateTriggering:
            [self.subtitleLabel setText:NSLocalizedString(@"释放刷新", nil)];
            break;
        case PRRefreshStateRefreshing:
            [self.subtitleLabel setText:NSLocalizedString(@"刷新中...", nil)];
            [self.titleLabelBottomContstraint setConstant:-8];
            [self layoutIfNeeded];
            [_subtitleLabel setAlpha:1.0f];
            break;
    }
    _state = state;
}

- (void)setLeftView:(UIView *)leftView
{
    [_leftView removeFromSuperview];
    
    [leftView cw_setLeft:0.0f];
    [leftView cw_setBottom:self.cw_height];
    [self addSubview:leftView];
    
    leftView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    _leftView = leftView;
}

- (void)setRightView:(UIView *)rightView
{
    [_rightView removeFromSuperview];
    
    [rightView cw_setRight:self.cw_width];
    [rightView cw_setBottom:self.cw_height];
    [self addSubview:rightView];
    
    rightView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    _rightView = rightView;
}

- (void)setTitle:(NSString *)title
{
    _title = nil;
    _title = [title copy];
    
    _titleLabel.text = title;
}

- (UIColor *)titleColor
{
    return [self.titleLabel textColor];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self.titleLabel setTextColor:titleColor];
}

- (UIColor *)subtitleColor
{
    return [self.subtitleLabel textColor];
}

- (void)setSubtitleColor:(UIColor *)subtitleColor
{
    [self.subtitleLabel setTextColor:subtitleColor];
}

- (void)pullToRefreshHeaderDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = [scrollView contentOffset].y + [scrollView contentInset].top;
    CGFloat alpha = MIN(1.0f, -offsetY/50.0f);
    [self.logo setAlpha:alpha];
        
    if (offsetY > 0.0f) {
        CGRect frame = self.frame;
        if (frame.origin.y != 0) {
            [self restore];
            frame.origin.y = 0;
            self.frame = frame;
        }
        return;
    }
    
    UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
    insets.top = -offsetY + [scrollView contentInset].top;
    scrollView.scrollIndicatorInsets = insets;
    
    CGRect frame = self.frame;
    [self setFrame:CGRectMake(frame.origin.x, -offsetY, frame.size.width, frame.size.height)];
    
    if (self.state == PRRefreshStateRefreshing) {
        return;
    }
    
    if (scrollView.isDragging) {
        if (-offsetY >= 60.0f) {
            self.state = PRRefreshStateTriggering;
        }
        else {
            self.state = PRRefreshStatePulling;
        }
    }
    
    [self.subtitleLabel setAlpha:alpha];
    [self.titleLabelBottomContstraint setConstant:alpha*-8];
    [self layoutIfNeeded];
    
    if (self.state == PRRefreshStateTriggering && !scrollView.isDragging) {
        if (self.refreshTriggeredBlock) {
            self.refreshTriggeredBlock();
        }
        self.state = PRRefreshStateRefreshing;
    }
}

- (void)restore
{
    self.state = PRRefreshStatePulling;
    
    [UIView animateWithDuration:.2 animations:^{
        [self.titleLabelBottomContstraint setConstant:0];
        [self layoutIfNeeded];
        [_subtitleLabel setAlpha:0.0f];
    }];
}

@end
