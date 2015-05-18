//
//  PRSectionHeader.m
//  PlainReader
//
//  Created by guojiubo on 14-6-7.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRSectionHeader.h"

@interface PRSectionHeader ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation PRSectionHeader

+ (void)initialize
{
    if (self != [PRSectionHeader class]) {
        return;
    }
    
    [[self appearance] setTextColor:[UIColor pr_darkGrayColor]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *blueView = [[UIView alloc] init];
        blueView.translatesAutoresizingMaskIntoConstraints = NO;
        blueView.backgroundColor = CW_HEXColor(0x34bcf5);
        [self addSubview:blueView];
        
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
        
        NSDictionary *viewDict = @{@"blueView": blueView, @"label": _label};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blueView(==3)]" options:0 metrics:nil views:viewDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blueView]|" options:0 metrics:nil views:viewDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[label]" options:0 metrics:nil views:viewDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:viewDict]];
    }
    return self;
}

- (NSString *)text
{
    return [self.label text];
}

- (void)setText:(NSString *)text
{
    [self.label setText:text];
}

- (UIColor *)textColor
{
    return [self.label textColor];
}

- (void)setTextColor:(UIColor *)textColor
{
    [self.label setTextColor:textColor];
}

@end
