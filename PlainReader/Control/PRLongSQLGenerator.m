//
//  PRSQLGenerator.m
//  PlainReader
//
//  Created by guojiubo on 10/27/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRLongSQLGenerator.h"

@implementation PRLongSQLGenerator

+ (void)generateSQLForInsertingArticle:(PRArticle *)article completion:(void (^) (NSString *sql, NSArray *arguments))completion
{
    if (!article.articleId) {
        // Must have article id
        return completion(nil, nil);
    }
    
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    NSMutableArray *bindingMark = [[NSMutableArray alloc] init];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    [columns addObject:@"id"];
    [arguments addObject:article.articleId];
    [bindingMark addObject:@"?"];
    
    if (article.title) {
        [columns addObject:@"title"];
        [arguments addObject:article.title];
        [bindingMark addObject:@"?"];
    }
    if (article.source) {
        [columns addObject:@"source"];
        [arguments addObject:article.source];
        [bindingMark addObject:@"?"];
    }
    if (article.summary) {
        [columns addObject:@"summary"];
        [arguments addObject:article.summary];
        [bindingMark addObject:@"?"];
    }
    if (article.pubTime) {
        [columns addObject:@"pubtime"];
        [arguments addObject:article.pubTime];
        [bindingMark addObject:@"?"];
    }
    if (article.content) {
        [columns addObject:@"content"];
        [arguments addObject:article.content];
        [bindingMark addObject:@"?"];
    }
    if (article.commentCount) {
        [columns addObject:@"cmt_count"];
        [arguments addObject:article.commentCount];
        [bindingMark addObject:@"?"];
    }
    if (article.sn) {
        [columns addObject:@"sn"];
        [arguments addObject:article.sn];
        [bindingMark addObject:@"?"];
    }
    if (article.thumb) {
        [columns addObject:@"thumb"];
        [arguments addObject:article.thumb];
        [bindingMark addObject:@"?"];
    }
    if (article.read) {
        [columns addObject:@"is_read"];
        [arguments addObject:article.read];
        [bindingMark addObject:@"?"];
    }
    if (article.cacheStatus) {
        [columns addObject:@"cache_status"];
        [arguments addObject:article.cacheStatus];
        [bindingMark addObject:@"?"];
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO article (%@) VALUES (%@)", [columns componentsJoinedByString:@","], [bindingMark componentsJoinedByString:@","]];
    completion(sql, arguments);
}

+ (void)generateSQLForUpdatingArticle:(PRArticle *)article completion:(void (^)(NSString *sql, NSArray *arguments))completion
{
    if (!article.articleId) {
        // Must have article id
        return completion(nil, nil);
    }
    
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    [columns addObject:@"id = ?"];
    [arguments addObject:article.articleId];
    
    if (article.title) {
        [columns addObject:@"title = ?"];
        [arguments addObject:article.title];
    }
    if (article.source) {
        [columns addObject:@"source = ?"];
        [arguments addObject:article.source];
    }
    if (article.summary) {
        [columns addObject:@"summary = ?"];
        [arguments addObject:article.summary];
    }
    if (article.pubTime) {
        [columns addObject:@"pubtime = ?"];
        [arguments addObject:article.pubTime];
    }
    if (article.content) {
        [columns addObject:@"content = ?"];
        [arguments addObject:article.content];
    }
    if (article.commentCount) {
        [columns addObject:@"cmt_count = ?"];
        [arguments addObject:article.commentCount];
    }
    if (article.sn) {
        [columns addObject:@"sn = ?"];
        [arguments addObject:article.sn];
    }
    if (article.thumb) {
        [columns addObject:@"thumb = ?"];
        [arguments addObject:article.thumb];
    }
    if (article.read) {
        [columns addObject:@"is_read = ?"];
        [arguments addObject:article.read];
    }
    if (article.cacheStatus) {
        [columns addObject:@"cache_status = ?"];
        [arguments addObject:article.cacheStatus];
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE article SET %@ WHERE id = %@", [columns componentsJoinedByString:@","], article.articleId];
    completion(sql, arguments);
}

@end
