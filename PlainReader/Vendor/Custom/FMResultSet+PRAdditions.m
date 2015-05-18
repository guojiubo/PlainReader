//
//  FMResultSet+PRAdditions.m
//  PlainReader
//
//  Created by guo on 10/26/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "FMResultSet+PRAdditions.h"

@implementation FMResultSet (PRAdditions)

- (NSNumber *)numberForColumnName:(NSString *)columnName
{
    id result = [self objectForColumnName:columnName];
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return result;
}

- (PRArticle *)toArticle
{
    PRArticle *article = [[PRArticle alloc] init];
    article.articleId = [self numberForColumnName:@"id"];
    article.title = [self stringForColumn:@"title"];
    article.source = [self stringForColumn:@"source"];
    article.summary = [self stringForColumn:@"summary"];
    article.pubTime = [self stringForColumn:@"pubtime"];
    article.content = [self stringForColumn:@"content"];
    article.commentCount = [self numberForColumnName:@"cmt_count"];
    article.sn = [self stringForColumn:@"sn"];
    article.thumb = [self stringForColumn:@"thumb"];
    article.read = [self numberForColumnName:@"is_read"];
    article.cacheStatus = [self numberForColumnName:@"cache_status"];
    return article;
}

- (PRArticle *)toRealtimeArticle
{
    PRArticle *article = [[PRArticle alloc] init];
    article.articleId = [self numberForColumnName:@"id"];
    article.title = [self stringForColumn:@"title"];
    article.pubTime = [self stringForColumn:@"pubtime"];
    article.commentCount = [self numberForColumnName:@"cmt_count"];
    article.thumb = [self stringForColumn:@"thumb"];
    article.read = [self numberForColumnName:@"is_read"];
    article.cacheStatus = [self numberForColumnName:@"cache_status"];
    return article;
}

- (PRArticle *)toTopCommentArticle
{
    PRArticle *article = [[PRArticle alloc] init];
    article.articleId = [self numberForColumnName:@"id"];
    article.title = [self stringForColumn:@"title"];
    return article;
}

- (PRTopComment *)toTopComment
{
    PRTopComment *topComment = [[PRTopComment alloc] init];
    topComment.topCommentId = [self numberForColumnName:@"id"];
    topComment.content = [self stringForColumn:@"content"];
    topComment.from = [self stringForColumn:@"location"];
    topComment.hashValue = [self stringForColumn:@"hash"];
    
    PRArticle *article = [[PRArticle alloc] init];
    article.articleId = [self numberForColumnName:@"article_id"];
    topComment.article = article;
    
    return topComment;
}

@end
