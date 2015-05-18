//
//  PRDatabase.h
//  PlainReader
//
//  Created by guo on 10/25/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRArticle.h"
#import "PRTopComment.h"

typedef NS_ENUM(NSInteger, PRWeeklyType) {
    PRWeeklyTypeRecommend,
    PRWeeklyTypeHot
};

@interface PRDatabase : NSObject

+ (instancetype)sharedDatabase;

- (void)prepareDatabase;

- (PRArticle *)articleForId:(NSNumber *)articleId;

// Insert or Update article
- (void)storeArticle:(PRArticle *)article;

- (void)updateReadField:(PRArticle *)article;

- (NSArray *)realtimesWithLastArticle:(PRArticle *)lastArticle limit:(NSUInteger)limit;

- (void)clearTopComments;

// Insert or Update top comment
- (void)storeTopComment:(PRTopComment *)topComment;

- (NSArray *)topCommentsWithLastTopComment:(PRTopComment *)topComment limit:(NSUInteger)limit;

- (void)clearWeekly;

- (void)storeArticle:(PRArticle *)article weeklyType:(PRWeeklyType)type;

- (NSArray *)weekly;

- (void)clearExpiredArticles:(void (^) (void))completion;

- (void)starArticle:(PRArticle *)article;

- (void)unstarArticle:(PRArticle *)article;

- (NSArray *)starredArticles;

- (BOOL)isArticleStarred:(PRArticle *)article;

- (NSArray *)starredArticleIds;

@end
