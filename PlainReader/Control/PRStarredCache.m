//
//  PRStarredCache.m
//  PlainReader
//
//  Created by guo on 11/29/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRStarredCache.h"
#import "PRDatabase.h"

@interface PRStarredCache ()

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation PRStarredCache

+ (instancetype)sharedCache
{
    static PRStarredCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[PRStarredCache alloc] init];
    });
    return cache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [[NSMutableDictionary alloc] init];
        
        NSArray *articleIds = [[PRDatabase sharedDatabase] starredArticleIds];
        for (NSNumber *aid in articleIds) {
            _cache[aid] = @YES;
        }
    }
    return self;
}

- (void)starArticle:(PRArticle *)article
{
    self.cache[article.articleId] = @YES;
}

- (void)unstarArticle:(PRArticle *)article
{
    [self.cache removeObjectForKey:article.articleId];
}

- (BOOL)isStarred:(PRArticle *)article
{
    return self.cache[article.articleId] != nil;
}

@end
