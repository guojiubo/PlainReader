//
//  PRCommentActionView.m
//  PlainReader
//
//  Created by guojiubo on 12/11/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRCommentActionView.h"

@implementation PRCommentActionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _supportButton = [[PRCellButton alloc] init];
    _supportButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_supportButton setTitleColor:[UIColor pr_lightGrayColor] forState:UIControlStateNormal];
    [_supportButton setTitleColor:[UIColor pr_redColor] forState:UIControlStateHighlighted];
    [_supportButton setTitleColor:[UIColor pr_redColor] forState:UIControlStateSelected];
    [_supportButton setImage:[UIImage imageNamed:@"comment_support_n"] forState:UIControlStateNormal];
    [_supportButton setImage:[UIImage imageNamed:@"comment_support_p"] forState:UIControlStateHighlighted];
    [_supportButton setImage:[UIImage imageNamed:@"comment_support_p"] forState:UIControlStateSelected];
    [self addSubview:_supportButton];
    
    _opposeButton = [[PRCellButton alloc] init];
    _opposeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_opposeButton setTitleColor:[UIColor pr_lightGrayColor] forState:UIControlStateNormal];
    [_opposeButton setTitleColor:[UIColor pr_redColor] forState:UIControlStateHighlighted];
    [_opposeButton setTitleColor:[UIColor pr_redColor] forState:UIControlStateSelected];
    [_opposeButton setImage:[UIImage imageNamed:@"comment_oppose_n"] forState:UIControlStateNormal];
    [_opposeButton setImage:[UIImage imageNamed:@"comment_oppose_p"] forState:UIControlStateHighlighted];
    [_opposeButton setImage:[UIImage imageNamed:@"comment_oppose_p"] forState:UIControlStateSelected];
    [self addSubview:_opposeButton];
    
    _replyButton = [[PRCellButton alloc] init];
    [_replyButton setImage:[UIImage imageNamed:@"comment_reply_n"] forState:UIControlStateNormal];
    [_replyButton setImage:[UIImage imageNamed:@"comment_reply_p"] forState:UIControlStateHighlighted];
    [self addSubview:_replyButton];
    
    _supportButton.translatesAutoresizingMaskIntoConstraints = NO;
    _opposeButton.translatesAutoresizingMaskIntoConstraints = NO;
    _replyButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_supportButton, _opposeButton, _replyButton);
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_supportButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_opposeButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_replyButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_supportButton(==60)][_opposeButton(==50)][_replyButton(==40)]" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_supportButton(==30)]" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_opposeButton(==30)]" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_replyButton(==30)]" options:kNilOptions metrics:nil views:views]];
}

- (void)setComment:(PRComment *)comment
{
    self.supportButton.userInfo = comment;
    self.opposeButton.userInfo = comment;
    self.replyButton.userInfo = comment;
    
    [self.supportButton setTitle:[@(comment.support) stringValue] forState:UIControlStateNormal];
    [self.opposeButton setTitle:[@(comment.oppose) stringValue] forState:UIControlStateNormal];
    [self.supportButton setSelected:comment.supported];
    [self.opposeButton setSelected:comment.opposed];
}

@end
