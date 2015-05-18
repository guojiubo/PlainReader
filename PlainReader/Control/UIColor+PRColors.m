//
//  UIColor+CBColors.m
//  PlainReader
//
//  Created by guojiubo on 11/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "UIColor+PRColors.h"

@implementation UIColor (PRColors)

+ (instancetype)pr_backgroundColor
{
    return [PRAppSettings sharedSettings].isNightMode ? CW_HEXColor(0x20242d) : [UIColor whiteColor];
}

+ (instancetype)pr_tableViewSeparatorColor
{
    return [PRAppSettings sharedSettings].isNightMode ? CW_HEXColor(0x00101a) : [UIColor colorWithWhite:0.8 alpha:1.0];
}

+ (instancetype)pr_blueColor
{
    return CW_RGBColor(66, 191, 231);
}

+ (instancetype)pr_lightGrayColor
{
    return CW_HEXColor(0x717377);
}

+ (instancetype)pr_darkGrayColor
{
    return CW_HEXColor(0x191919);
}

+ (instancetype)pr_redColor
{
    return CW_HEXColor(0xff2965);
}

+ (instancetype)pr_darkNavigationBarColor
{
    return CW_HEXColor(0x1e2128);
}

@end
