//
//  UIImage+FutureStep.h
//  PlainReader
//
//  Created by guojiubo on 14-5-10.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PRAdditions)

- (UIImage *)pr_thumbnailWithSize:(CGSize)size;

+ (UIImage *)pr_animatedGIFNamed:(NSString *)name;

+ (UIImage *)pr_animatedGIFWithData:(NSData *)data;

- (UIImage *)pr_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
