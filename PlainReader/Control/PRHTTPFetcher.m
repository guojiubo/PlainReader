//
//  PRHTMLFetcher.m
//  PlainReader
//
//  Created by guojiubo on 14-3-24.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRHTTPFetcher.h"
#import "PRArticleParser.h"
#import "TFHppleElement+PRAdditions.h"
#import "PRTopCommentCell.h"
#import "PRDatabase.h"
#import "PRTopComment.h"

NSString *const PRHTTPFetcherDidFetchCommentsNotification = @"PRHTTPFetcherDidFetchCommentsNotification";

static NSString *const PRHTTPFetcherErrorDomain = @"PRHTTPFetcherErrorDomain";

static NSString *CBHomePageToken = nil;

@interface PRHTTPFetcher ()

@end

@implementation PRHTTPFetcher

#pragma mark - Helpers

- (AFHTTPRequestOperationManager * )JSONRequestOperationManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // fixed server text/html issue
    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [manager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
    return manager;
}

- (AFHTTPRequestOperationManager *)HTTPRequestOperationManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}

- (NSError *)parametersError
{
    return [NSError cw_errorWithDomain:PRHTTPFetcherErrorDomain code:-1024 message:@"Parameter Error"];
}

- (NSError *)serverError
{
    return [NSError cw_errorWithDomain:PRHTTPFetcherErrorDomain code:-1023 message:@"Bad Server Response"];
}

- (void)safelyCallback:(CWHTTPFetcherBlock)block
{
    DDLogInfo(@"%@", [(AFHTTPRequestOperation *)self.requestOperation responseString]);

    if (!block) {
        return;
    }
    
    if (self.error) {
        if ([self.error code] == NSURLErrorCancelled) {
            return;
        }
        
        if ([self.requestOperation isKindOfClass:[AFHTTPRequestOperation class]]) {
            AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)self.requestOperation;
            DDLogError(@"%@\n%@", self.error, [operation responseString]);
        }
    }
    
    if ([NSThread isMainThread]) {
        block(self, self.error);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        block(self, self.error);
    });
}

- (NSString *)articleIDFromLink:(NSString *)link
{
    if (!link) {
        return nil;
    }
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"_(\\d*)\\." options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [reg firstMatchInString:link options:0 range:NSMakeRange(0, link.length)];
    if (match.numberOfRanges > 0) {
        return [link substringWithRange:[match rangeAtIndex:1]];
    }
    return nil;
}

- (NSString *)cookiePHPSESSID
{
    NSHTTPCookieStorage *cs = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cs cookies]) {
        if ([[cookie name] isEqualToString:@"PHPSESSID"]) {
            return [cookie value];
        }
    }
    return nil;
}

- (NSString *)cookieCSRF_TOKEN
{
    NSHTTPCookieStorage *cs = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cs cookies]) {
        if ([[cookie name] isEqualToString:@"csrf_token"]) {
            return [cookie value];
        }
    }
    return nil;
}

#pragma mark - APIs

- (void)fetchHomePage:(CWHTTPFetcherBlock)block
{
    AFHTTPRequestOperationManager *m = [self HTTPRequestOperationManager];
    self.requestOperation = [m GET:@"http://www.cnbeta.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:operation.responseData];
            NSArray *items = [hpple searchWithXPathQuery:@"//div[@class=\"all_news_wildlist\"]//div[@class=\"item\"]"];
            if ([items count] == 0) {
                self.error = [self serverError];
                [self safelyCallback:block];
                return;
            }
            
            // TOKEN
            NSString *wholeHTML = [[NSString alloc] initWithData:hpple.data encoding:NSUTF8StringEncoding];
            if (wholeHTML) {
                NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"TOKEN:\"([^\"]*)\"" options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult *match = [reg firstMatchInString:wholeHTML options:0  range:NSMakeRange(0, wholeHTML.length)];
                if (match.numberOfRanges > 0) {
                    CBHomePageToken = [wholeHTML substringWithRange:[match rangeAtIndex:1]];
                }
            }
            
            for (TFHppleElement *element in items) {
                PRArticle *article = [[PRArticle alloc] init];
                NSString *divId = [element objectForKey:@"id"];
                NSString *articleIdString = [[divId componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                article.articleId = @([articleIdString integerValue]);
                article.title = [[[element findFirstSubnodeWithClassName:@"title"] findFirstSubnodeWithTagName:@"a"] text];
                article.pubTime = [[[element findFirstSubnodeWithClassName:@"tj"] findFirstSubnodeWithTagName:@"em"] text];
                NSString *commentCountString = [[[element findFirstSubnodeWithClassName:@"gray"] findFirstSubnodeWithTagName:@"em"] text];
                article.commentCount = @([commentCountString integerValue]);
                article.thumb = [[[element findFirstSubnodeWithClassName:@"picno"] findFirstSubnodeWithTagName:@"img"] objectForKey:@"src"];
                
                [[PRDatabase sharedDatabase] storeArticle:article];
            }
            
            [self safelyCallback:block];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)fetchRealtimeWithPage:(NSUInteger)page done:(CWHTTPFetcherBlock)block
{
    if (!CBHomePageToken) {
        self.error = [self parametersError];
        [self safelyCallback:block];
        return;
    }
    
    page = MAX(2, page);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"csrf_token"] = CBHomePageToken;
    parameters[@"type"] = @"all";
    parameters[@"page"] = @(page);
    int64_t time = (int64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    parameters[@"_"] = @(time);
    
    AFHTTPRequestOperationManager *m = [self JSONRequestOperationManager];
    [m.requestSerializer setValue:@"http://www.cnbeta.com/" forHTTPHeaderField:@"Referer"];

    self.requestOperation = [m GET:@"http://www.cnbeta.com/more" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *json = responseObject;
            if (![json[@"state"] isEqualToString:@"success"]) {
                self.error = [self serverError];
                [self safelyCallback:block];
                
                return;
            }
            
            NSArray *list = json[@"result"][@"list"];
            for (NSDictionary *dict in list) {
                PRArticle *article = [[PRArticle alloc] init];
                article.articleId = dict[@"sid"];
                article.title = dict[@"title"];
                article.commentCount = dict[@"comments"];
                article.pubTime = dict[@"inputtime"];
                article.thumb = dict[@"thumb"];
                
                [[PRDatabase sharedDatabase] storeArticle:article];
            }
            
            [self safelyCallback:block];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)fetchWeekly:(CWHTTPFetcherBlock)block
{
    AFHTTPRequestOperationManager *manager = [self HTTPRequestOperationManager];
    self.requestOperation = [manager GET:@"http://m.cnbeta.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:operation.responseData];
            NSArray *modules = [hpple searchWithXPathQuery:@"//div[@class=\"module\"]/ul"];
            
            if (modules.count != 4) {
                self.error = [self serverError];
                [self safelyCallback:block];
                return;
            }
            
            [[PRDatabase sharedDatabase] clearWeekly];
            
            // 人气推荐
            TFHppleElement *module = modules[1];
            NSArray *lis = [module childrenWithTagName:@"li"];
            for (TFHppleElement *element in lis) {
                NSData *recommendData = [[element raw] dataUsingEncoding:NSUTF8StringEncoding];
                TFHpple *recommendHpple = [[TFHpple alloc] initWithHTMLData:recommendData];
                
                if ([[element objectForKey:@"class"] isEqualToString:@"module_imgNewsTwoCol"]) {
                    TFHppleElement *aNode = [[recommendHpple searchWithXPathQuery:@"//a"] firstObject];
                    NSString *link = [aNode objectForKey:@"href"];
                    NSString *aidString = [self articleIDFromLink:link];
                    if (aidString) {
                        PRArticle *article = [[PRArticle alloc] init];
                        article.articleId = @([aidString integerValue]);
                        
                        article.title = [[[recommendHpple searchWithXPathQuery:@"//p"] lastObject] text];
                        article.thumb = [[[recommendHpple searchWithXPathQuery:@"//img"] firstObject] objectForKey:@"src"];
                        
                        [[PRDatabase sharedDatabase] storeArticle:article weeklyType:PRWeeklyTypeRecommend];
                    }
                }
                else {
                    TFHppleElement *aNode = [[recommendHpple searchWithXPathQuery:@"//a"] firstObject];
                    NSString *link = [aNode objectForKey:@"href"];
                    NSString *aidString = [self articleIDFromLink:link];
                    if (aidString) {
                        PRArticle *article = [[PRArticle alloc] init];
                        article.articleId = @([aidString integerValue]);
                        article.title = aNode.text;
                        
                        [[PRDatabase sharedDatabase] storeArticle:article weeklyType:PRWeeklyTypeRecommend];
                    }
                }
            }
            
            // 热评资讯
            module = modules[2];
            lis = [module childrenWithTagName:@"li"];
            for (TFHppleElement *element in lis) {
                NSData *hotCommentData = [[element raw] dataUsingEncoding:NSUTF8StringEncoding];
                TFHpple *hotCommentHpple = [[TFHpple alloc] initWithHTMLData:hotCommentData];

                if ([[element objectForKey:@"class"] isEqualToString:@"module_imgNewsTwoCol"]) {
                    TFHppleElement *aNode = [[hotCommentHpple searchWithXPathQuery:@"//a"] firstObject];
                    NSString *link = [aNode objectForKey:@"href"];
                    NSString *aidString = [self articleIDFromLink:link];
                    if (aidString) {
                        PRArticle *article = [[PRArticle alloc] init];
                        article.articleId = @([aidString integerValue]);
                        
                        article.title = [[[hotCommentHpple searchWithXPathQuery:@"//p"] lastObject] text];
                        article.thumb = [[[hotCommentHpple searchWithXPathQuery:@"//img"] firstObject] objectForKey:@"src"];
                        
                        [[PRDatabase sharedDatabase] storeArticle:article weeklyType:PRWeeklyTypeHot];
                    }
                }
                else {
                    TFHppleElement *aNode = [[hotCommentHpple searchWithXPathQuery:@"//a"] firstObject];
                    NSString *link = [aNode objectForKey:@"href"];
                    NSString *aidString = [self articleIDFromLink:link];
                    if (aidString) {
                        PRArticle *article = [[PRArticle alloc] init];
                        article.articleId = @([aidString integerValue]);
                        article.title = aNode.text;
                        
                        [[PRDatabase sharedDatabase] storeArticle:article weeklyType:PRWeeklyTypeHot];
                    }
                }
            }
            
            [self safelyCallback:block];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)fetchArticle:(NSNumber *)articleId useCache:(BOOL)useCache done:(CWHTTPFetcherBlock)block;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PRArticle *article = [[PRDatabase sharedDatabase] articleForId:articleId];
        self.responseObject = article;

        if (useCache && article.content) {
            [self safelyCallback:block];
            return;
        }
        
        NSString *api = [NSString stringWithFormat:@"http://www.cnbeta.com/articles/%@.htm", articleId];
        AFHTTPRequestOperationManager *manager = [self HTTPRequestOperationManager];
        self.requestOperation = [manager GET:api parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:operation.responseData];
                [PRArticleParser parseArticle:article hpple:hpple];
                article.cacheStatus = @(PRArticleCacheStatusCached);
                [[PRDatabase sharedDatabase] storeArticle:article];
                
                [self safelyCallback:block];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.error = error;
            [self safelyCallback:block];
        }];
    });
}

- (void)fetchTopCommentsWithPage:(NSUInteger)page done:(CWHTTPFetcherBlock)block
{
    NSString *api = [NSString stringWithFormat:@"http://m.cnbeta.com/jh_%lu.htm", (unsigned long)page];
    AFHTTPRequestOperationManager *manager = [self HTTPRequestOperationManager];
    self.requestOperation = [manager GET:api parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:operation.responseData];
            NSArray *commentElements = [hpple searchWithXPathQuery:@"//ul[@class=\"module_list\"]/li"];
            if ([commentElements count] == 0) {
                self.error = [self serverError];
                [self safelyCallback:block];
                return;
            }
            
            if (page == 1) {
                [[PRDatabase sharedDatabase] clearTopComments];
            }
            
            for (TFHppleElement *commentElement in commentElements) {
                NSData *commentData = [[commentElement raw] dataUsingEncoding:NSUTF8StringEncoding];
                TFHpple *commentHpple = [[TFHpple alloc] initWithHTMLData:commentData];
                
                PRTopComment *comment = [[PRTopComment alloc] init];
                comment.content = [(TFHppleElement *)[[commentHpple searchWithXPathQuery:@"//div[@class=\"jh_title jh_text\"]/a"] firstObject] text];
                comment.from = [(TFHppleElement *)[[commentHpple searchWithXPathQuery:@"//strong"] firstObject] text];
                
                TFHppleElement *aNode = [[commentHpple searchWithXPathQuery:@"//a"] lastObject];
                PRArticle *article = [[PRArticle alloc] init];
                NSString *href = [aNode objectForKey:@"href"];
                NSString *aid = [self articleIDFromLink:href];
                if (aid) {
                    article.articleId = @([aid integerValue]);
                }
                article.title = [aNode text];
                [[PRDatabase sharedDatabase] storeArticle:article];
                
                comment.article = article;
                [[PRDatabase sharedDatabase] storeTopComment:comment];
            }
            
            [self safelyCallback:block];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)fetchCommentsOfArticle:(PRArticle *)article done:(CWHTTPFetcherBlock)block
{
    NSString *api = [NSString stringWithFormat:@"http://www.cnbeta.com/cmt"];
    NSString *op = [NSString stringWithFormat:@"1,%@,%@", article.articleId, article.sn];
    
    AFHTTPRequestOperationManager *manager = [self JSONRequestOperationManager];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    NSString *phpsession = [self cookiePHPSESSID];
    NSString *token = [self cookieCSRF_TOKEN];
    if (phpsession && token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@;csrf_token=%@", phpsession, token] forHTTPHeaderField:@"Cookie"];
    }
    
    self.requestOperation = [manager POST:api parameters:@{@"op":op} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *json = responseObject;
            if (![json[@"state"] isEqualToString:@"success"]) {
                if ([json[@"state"] isEqualToString:@"error"]) {
                    self.error = [NSError cw_errorWithDomain:PRHTTPFetcherErrorDomain code:[json[@"error_code"] integerValue] message:json[@"error"]];
                }
                else {
                    self.error = [self serverError];
                }
                [[NSNotificationCenter defaultCenter] cw_postNotificationOnMainThreadName:PRHTTPFetcherDidFetchCommentsNotification sender:self userObject:nil];
                [self safelyCallback:block];
                
                return;
            }
            
            NSDictionary *resultDict = json[@"result"];
            
            NSMutableArray *all = [[NSMutableArray alloc] init];
            NSMutableArray *hotComments = [[NSMutableArray alloc] init];
            NSMutableArray *comments = [[NSMutableArray alloc] init];
            
            NSArray *cmntList = resultDict[@"cmntlist"];
            NSDictionary *cmntStore = resultDict[@"cmntstore"];
            NSDictionary *cmntDict = resultDict[@"cmntdict"];
            
            NSArray *hotList = resultDict[@"hotlist"];
            for (NSDictionary *hotDict in hotList) {
                NSString *cid = hotDict[@"tid"];
                NSDictionary *commentDict = cmntStore[cid];
                
                if (commentDict) {
                    PRComment *hotComment = [PRComment instanceFromDictionary:commentDict];
                    hotComment.isHot = YES;
                    [hotComments addObject:hotComment];
                }
            }
            
            if ([hotComments count] > 0) {
                [all addObject:hotComments];
            }
            
            for (NSDictionary *d in cmntList) {
                NSString *cid = d[@"tid"];
                NSDictionary *commentDict = cmntStore[cid];
                if (commentDict) {
                    PRComment *comment = [PRComment instanceFromDictionary:commentDict];
                    
                    NSMutableArray *subComments = [[NSMutableArray alloc] init];
                    
                    if ([cmntDict isKindOfClass:[NSDictionary class]]) {
                        NSArray *subArray = cmntDict[cid];
                        for (int i = 1; i <= subArray.count; i++) {
                            NSDictionary *sub = subArray[i-1];
                            NSDictionary *subCommentDict = cmntStore[sub[@"tid"]];
                            if (subCommentDict) {
                                PRComment *subComment = [PRComment instanceFromDictionary:subCommentDict];
                                subComment.floorNumber = i;
                                [subComments addObject:subComment];
                            }
                        }
                        comment.subcomments = subComments;
                    }
                    comment.floorNumber = cmntList.count - [cmntList indexOfObject:d];
                    [comments addObject:comment];
                }
            }
            
            if ([comments count] > 0) {
                [all addObject:comments];
            }
            self.responseObject = all;
            [[NSNotificationCenter defaultCenter] cw_postNotificationOnMainThreadName:PRHTTPFetcherDidFetchCommentsNotification sender:self userObject:all];
            [self safelyCallback:block];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] cw_postNotificationOnMainThreadName:PRHTTPFetcherDidFetchCommentsNotification sender:self userObject:nil];
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)vote:(PRComment *)comment support:(BOOL)support done:(CWHTTPFetcherBlock)block
{
    NSString *token = [self cookieCSRF_TOKEN];
    if (!token) {
        self.error = [self parametersError];
        [self safelyCallback:block];
        return;
    }
    
    NSString *api = [NSString stringWithFormat:@"http://www.cnbeta.com/comment"];
    AFHTTPRequestOperationManager *manager = [self JSONRequestOperationManager];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

    NSString *phpsession = [self cookiePHPSESSID];
    if (phpsession) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@;csrf_token=%@", phpsession, token] forHTTPHeaderField:@"Cookie"];
    }

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:support ? @"support" : @"against" forKey:@"op"];
    [parameters setObject:token forKey:@"csrf_token"];
    [parameters setObject:comment.aid forKey:@"sid"];
    [parameters setObject:comment.cid forKey:@"tid"];

    self.requestOperation = [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = responseObject;
        if (![json[@"state"] isEqualToString:@"success"]) {
            self.error = [self serverError];
            [self safelyCallback:block];
            return;
        }
        
        [self safelyCallback:block];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)fetchSecurityCodeForArticle:(PRArticle *)article done:(CWHTTPFetcherBlock)block
{
    NSString *api = [NSString stringWithFormat:@"http://www.cnbeta.com/captcha?refresh=1"];
    AFHTTPRequestOperationManager *manager = [self JSONRequestOperationManager];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    NSString *phpsession = [self cookiePHPSESSID];
    if (phpsession) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@", phpsession] forHTTPHeaderField:@"Cookie"];
    }
    
    NSString *referer = [NSString stringWithFormat:@"http://cnbeta.com/articles/%@.htm", [article articleId]];
    [manager.requestSerializer setValue:referer forHTTPHeaderField:@"Referer"];
    
    self.requestOperation = [manager GET:api parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = responseObject;
        NSString *url = json[@"url"];
        if ([url length] == 0) {
            self.error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            [self safelyCallback:block];
            
            return;
        }
        
        NSString *URLString = [NSString stringWithFormat:@"http://www.cnbeta.com%@", url];
        [self fetchSecurityCodeImageWithURLString:URLString article:article done:block];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)fetchSecurityCodeImageWithURLString:(NSString *)URLString article:(PRArticle *)article done:(CWHTTPFetcherBlock)block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    NSString *phpsession = [self cookiePHPSESSID];
    if (phpsession) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@", phpsession] forHTTPHeaderField:@"Cookie"];
    }
    
    NSString *referer = [NSString stringWithFormat:@"http://cnbeta.com/articles/%@.htm", [article articleId]];
    [manager.requestSerializer setValue:referer forHTTPHeaderField:@"Referer"];
    
    self.requestOperation = [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = [UIImage imageWithData:operation.responseData];
        self.responseObject = image;
        [self safelyCallback:block];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@", error);
        
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)postCommentToArticle:(PRArticle *)article content:(NSString *)content securityCode:(NSString *)code done:(CWHTTPFetcherBlock)block
{
    NSString *api = [NSString stringWithFormat:@"http://www.cnbeta.com/comment"];
    AFHTTPRequestOperationManager *manager = [self JSONRequestOperationManager];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    NSString *token = [self cookieCSRF_TOKEN];
    NSString *phpsession = [self cookiePHPSESSID];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@;csrf_token=%@", phpsession, token] forHTTPHeaderField:@"Cookie"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"publish" forKey:@"op"];
    [parameters setObject:token forKey:@"csrf_token"];
    [parameters setObject:article.articleId forKey:@"sid"];
    [parameters setObject:code forKey:@"seccode"];
    [parameters setObject:content forKey:@"content"];
    
    self.requestOperation = [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = responseObject;
        if (![json[@"state"] isEqualToString:@"success"]) {
            if ([json[@"state"] isEqualToString:@"error"]) {
                self.error = [NSError cw_errorWithDomain:PRHTTPFetcherErrorDomain code:[json[@"error_code"] integerValue] message:json[@"error"]];
            }
            else {
                self.error = [self serverError];
            }
            
            [self safelyCallback:block];
            return;
        }
        
        [self safelyCallback:block];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

- (void)replyComment:(PRComment *)comment content:(NSString *)content securityCode:(NSString *)code done:(CWHTTPFetcherBlock)block
{
    NSString *api = [NSString stringWithFormat:@"http://www.cnbeta.com/comment"];
    AFHTTPRequestOperationManager *manager = [self JSONRequestOperationManager];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    NSString *token = [self cookieCSRF_TOKEN];
    NSString *phpsession = [self cookiePHPSESSID];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@;csrf_token=%@", phpsession, token] forHTTPHeaderField:@"Cookie"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"publish" forKey:@"op"];
    [parameters setObject:token forKey:@"csrf_token"];
    [parameters setObject:comment.aid forKey:@"sid"];
    [parameters setObject:comment.cid forKey:@"pid"];
    [parameters setObject:code forKey:@"seccode"];
    [parameters setObject:content forKey:@"content"];
    
    self.requestOperation = [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = responseObject;
        if (![json[@"state"] isEqualToString:@"success"]) {
            if ([json[@"state"] isEqualToString:@"error"]) {
                self.error = [NSError cw_errorWithDomain:PRHTTPFetcherErrorDomain code:[json[@"error_code"] integerValue] message:json[@"error"]];
            }
            else {
                self.error = [self serverError];
            }
            
            [self safelyCallback:block];
            return;
        }
        
        [self safelyCallback:block];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.error = error;
        [self safelyCallback:block];
    }];
}

@end
