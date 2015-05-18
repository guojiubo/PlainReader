//
//  PREmoticon.m
//  PlainReader
//
//  Created by guojiubo on 14-6-29.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PREmoticon.h"

@interface PREmoticon ()

+ (NSCache *)sharedCache;

@end

@implementation PREmoticon

+ (NSCache *)sharedCache
{
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}

- (NSData *)imageData
{
    NSCache *cache = [[self class] sharedCache];
    NSData *data = [cache objectForKey:self.imageName];
    if (data) {
        return data;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[self.imageName stringByAppendingString:@"@2x"] ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            [cache setObject:data forKey:self.imageName];
            return data;
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:self.imageName ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            [cache setObject:data forKey:self.imageName];
            return data;
        }
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.imageName ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            [cache setObject:data forKey:self.imageName];
            return data;
        }
    }
    
    return nil;
}

@end
