//
//  PRTableViewCell.m
//  PlainReader
//
//  Created by guo on 5/17/15.
//  Copyright (c) 2015 GUOJIUBO. All rights reserved.
//

#import "PRTableViewCell.h"

@implementation PRTableViewCell

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.contentView setBackgroundColor:backgroundColor];
    
    UIView *view = [[UIView alloc] init];
    CGFloat red, green, blue, alpha;
    [backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    view.backgroundColor = [UIColor colorWithRed:red*.85 green:green*.85 blue:blue*.85 alpha:alpha];
    self.selectedBackgroundView = view;
}

@end
