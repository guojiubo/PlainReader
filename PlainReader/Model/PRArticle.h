//
//  PRArticle.h
//  PlainReader
//
//  Created by guo on 10/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PRArticleCacheStatus) {
    PRArticleCacheStatusNone,
    PRArticleCacheStatusCached,
    PRArticleCacheStatusFailed
};

@interface PRArticle : NSObject

@property (nonatomic, copy) NSNumber *articleId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *pubTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *commentCount;
@property (nonatomic, copy) NSString *sn;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSNumber *read;
@property (nonatomic, copy) NSNumber *cacheStatus;
@property (nonatomic, readonly, copy) NSString *formattedTime;
@property (nonatomic, readonly) NSArray *imgSrcs;

- (BOOL)isStarred;

- (NSString *)toHTML;

@end
