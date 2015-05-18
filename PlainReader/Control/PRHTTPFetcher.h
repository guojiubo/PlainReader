//
//  PRHTMLFetcher.h
//  PlainReader
//
//  Created by guojiubo on 14-3-24.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRArticle.h"
#import "PRComment.h"

extern NSString *const PRHTTPFetcherDidFetchCommentsNotification;

@interface PRHTTPFetcher : CWHTTPFetcher

- (void)fetchHomePage:(CWHTTPFetcherBlock)block;

- (void)fetchRealtimeWithPage:(NSUInteger)page done:(CWHTTPFetcherBlock)block;

- (void)fetchWeekly:(CWHTTPFetcherBlock)block;

- (void)fetchArticle:(NSNumber *)articleId useCache:(BOOL)useCache done:(CWHTTPFetcherBlock)block;

- (void)fetchTopCommentsWithPage:(NSUInteger)page done:(CWHTTPFetcherBlock)block;

- (void)fetchCommentsOfArticle:(PRArticle *)article done:(CWHTTPFetcherBlock)block;

- (void)vote:(PRComment *)comment support:(BOOL)support done:(CWHTTPFetcherBlock)block;

- (void)fetchSecurityCodeForArticle:(PRArticle *)article done:(CWHTTPFetcherBlock)block;

- (void)postCommentToArticle:(PRArticle *)article content:(NSString *)content securityCode:(NSString *)code done:(CWHTTPFetcherBlock)block;

- (void)replyComment:(PRComment *)comment content:(NSString *)content securityCode:(NSString *)code done:(CWHTTPFetcherBlock)block;

@end
