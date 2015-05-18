//
//  PRStarredCache.h
//  PlainReader
//
//  Created by guo on 11/29/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRStarredCache : NSObject

+ (instancetype)sharedCache;

- (void)starArticle:(PRArticle *)article;

- (void)unstarArticle:(PRArticle *)article;

- (BOOL)isStarred:(PRArticle *)article;

@end
