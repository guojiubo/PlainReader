//
//  PRDatabase.m
//  PlainReader
//
//  Created by guo on 10/25/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRDatabase.h"
#import <FMDB.h>
#import "FMResultSet+PRAdditions.h"
#import "PRLongSQLGenerator.h"
#import "PRStarredCache.h"

@interface PRDatabase ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation PRDatabase

#pragma mark - Initialize

+ (instancetype)sharedDatabase
{
    static PRDatabase *database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[PRDatabase alloc] init];
    });
    return database;
}

- (void)prepareDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:[self dbPath]]) {
            NSURL *prototypeDBURL = [[NSBundle mainBundle] URLForResource:@"plainreader" withExtension:@"db"];
            NSError *error = nil;
            [fm copyItemAtURL:prototypeDBURL toURL:[NSURL fileURLWithPath:[self dbPath]] error:&error];
            if (error) {
                DDLogError(@"%@", error);
            }
        }
        
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    });
}

- (NSString *)dbPath
{
    static NSString *dbPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docPath = [UIApplication cw_documentsPath];
        dbPath = [docPath stringByAppendingPathComponent:@"plainreader.db"];
    });
    return dbPath;
}

#pragma mark - Public

- (PRArticle *)articleForId:(NSNumber *)articleId
{
    __block PRArticle *article = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM article WHERE id = ?", articleId];
        while ([s next]) {
            article = [s toArticle];
        }
    }];
    return article;
}

- (void)storeArticle:(PRArticle *)article
{
    if ([article.title length] == 0) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSUInteger totalCount = [db intForQuery:@"SELECT COUNT (id) FROM article WHERE id = ?", article.articleId];
        if (totalCount > 0) {
            [PRLongSQLGenerator generateSQLForUpdatingArticle:article completion:^(NSString *sql, NSArray *arguments) {
                BOOL result = [db executeUpdate:sql withArgumentsInArray:arguments];
                if (!result) {
                    DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
                }
            }];
        }
        else {
            [PRLongSQLGenerator generateSQLForInsertingArticle:article completion:^(NSString *sql, NSArray *arguments) {
                BOOL result = [db executeUpdate:sql withArgumentsInArray:arguments];
                if (!result) {
                    DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
                }
            }];
        }
    }];
}

- (void)updateReadField:(PRArticle *)article
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE article SET is_read = ? WHERE id = ?", article.read, article.articleId];
    }];
}

- (NSArray *)realtimesWithLastArticle:(PRArticle *)lastArticle limit:(NSUInteger)limit
{
    NSString *sql = nil;
    if (lastArticle) {
        sql = [NSString stringWithFormat:@"SELECT id, title, pubtime, cmt_count, thumb, is_read, cache_status FROM article WHERE id < %@ AND (pubtime IS NOT NULL OR pubtime != '') ORDER BY id DESC LIMIT %@", lastArticle.articleId, [@(limit) stringValue]];
    }
    else {
        sql = [NSString stringWithFormat:@"SELECT id, title, pubtime, cmt_count, thumb, is_read, cache_status FROM article WHERE (pubtime IS NOT NULL OR pubtime != '') ORDER BY id DESC LIMIT %@", [@(limit) stringValue]];
    }
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:sql];
        while ([s next]) {
            PRArticle *article = [s toRealtimeArticle];
            [results addObject:article];
        }
    }];
    return results;
}

- (void)clearTopComments
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"DELETE FROM top_comment"];
        if (!result) {
            DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }];
}

- (void)storeTopComment:(PRTopComment *)topComment
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSUInteger totalCount = [db intForQuery:@"SELECT COUNT (id) FROM top_comment WHERE hash = ?", topComment.hashValue];
        if (totalCount == 0) {
            BOOL result = [db executeUpdate:@"INSERT INTO top_comment (id, hash, content, location, article_id) VALUES (NULL, ?, ?, ?, ?)", topComment.hashValue, topComment.content, topComment.from, [topComment.article articleId]];
            if (!result) {
                DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
            }
        }
    }];
}

- (NSArray *)topCommentsWithLastTopComment:(PRTopComment *)topComment limit:(NSUInteger)limit
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM top_comment WHERE id > ? ORDER BY id ASC LIMIT ?", topComment ? topComment.topCommentId : @(0), @(limit)];
        while ([s next]) {
            PRTopComment *comment = [s toTopComment];
            
            NSString *articleTitle = [db stringForQuery:@"SELECT title FROM article WHERE id = ?", [comment.article articleId]];
            if (!articleTitle) {
                continue;
            }
            [comment.article setTitle:articleTitle];
            [results addObject:comment];
        }
    }];
    return results;
}

- (void)clearWeekly
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"DELETE FROM weekly"];
        if (!result) {
            DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }];
}

- (void)storeArticle:(PRArticle *)article weeklyType:(PRWeeklyType)type
{
    if ([article.title length] == 0) {
        return;
    }
    
    [self storeArticle:article];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"INSERT INTO weekly (article_id, type) VALUES(?, ?)", [article articleId], @(type)];
        if (!result) {
            DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }];
}

- (NSArray *)weekly
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *hots = [[NSMutableArray alloc] init];
    NSMutableArray *recommends = [[NSMutableArray alloc] init];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM weekly WHERE type = ? ORDER BY article_id DESC", @(PRWeeklyTypeHot)];
        while ([s next]) {
            NSNumber *articleId = [s numberForColumnName:@"article_id"];

            FMResultSet *ss = [db executeQuery:@"SELECT id, title, pubtime, cmt_count, thumb, is_read, cache_status FROM article WHERE id = ?", articleId];
            while ([ss next]) {
                PRArticle *article = [ss toRealtimeArticle];
                [hots addObject:article];
            }
        }
        
        s = [db executeQuery:@"SELECT * FROM weekly WHERE type = ? ORDER BY article_id DESC", @(PRWeeklyTypeRecommend)];
        while ([s next]) {
            NSNumber *articleId = [s numberForColumnName:@"article_id"];
            
            FMResultSet *ss = [db executeQuery:@"SELECT id, title, pubtime, cmt_count, thumb, is_read, cache_status FROM article WHERE id = ?", articleId];
            while ([ss next]) {
                PRArticle *article = [ss toRealtimeArticle];
                [recommends addObject:article];
            }
        }
        
        [results addObjectsFromArray:@[hots, recommends]];
    }];
    
    return results;
}

- (void)clearExpiredArticles:(void (^) (void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSDate *sevenDaysAgo = [NSDate dateWithTimeIntervalSinceNow:-(60 * 60 * 24 * 7)];
            NSTimeInterval interval = [sevenDaysAgo timeIntervalSince1970];
            BOOL result = [db executeUpdate:
                           @"DELETE FROM article WHERE pubtime <= Datetime(?, 'unixepoch', 'localtime') "
                           "AND id NOT IN (SELECT article_id FROM weekly) "
                           "AND id NOT IN (SELECT article_id FROM starred) "
                           "AND id NOT IN (SELECT article_id FROM top_comment)", @(interval)];
            if (!result) {
                DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
            }
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

- (void)starArticle:(PRArticle *)article
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"INSERT OR REPLACE INTO starred (article_id, time) VALUES (?, ?)", article.articleId, @((int)[[NSDate date] timeIntervalSince1970])];
        if (!result) {
            DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
        [[PRStarredCache sharedCache] starArticle:article];
    }];
}

- (void)unstarArticle:(PRArticle *)article
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"DELETE FROM starred WHERE article_id = ?", article.articleId];
        if (!result) {
            DDLogError(@"%d : %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
        [[PRStarredCache sharedCache] unstarArticle:article];
    }];
}

- (NSArray *)starredArticles
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM article, starred WHERE article.id = starred.article_id ORDER BY starred.time DESC"];
        while ([s next]) {
            PRArticle *article = [s toRealtimeArticle];
            [results addObject:article];
        }
    }];
    return results;
}

- (BOOL)isArticleStarred:(PRArticle *)article
{
    __block BOOL isStarred = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSUInteger totalCount = [db intForQuery:@"SELECT COUNT (article_id) FROM starred WHERE article_id = ?", article.articleId];
        isStarred = totalCount > 0;
    }];
    return isStarred;
}

- (NSArray *)starredArticleIds
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:@"SELECT article_id FROM starred"];
        while ([s next]) {
            NSNumber *aid = [s numberForColumnName:@"article_id"];
            [results addObject:aid];
        }
    }];
    return results;
}

@end