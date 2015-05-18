//
//  PRSQLGenerator.h
//  PlainReader
//
//  Created by guojiubo on 10/27/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRArticle.h"

@interface PRLongSQLGenerator : NSObject

+ (void)generateSQLForInsertingArticle:(PRArticle *)article completion:(void (^) (NSString *sql, NSArray *arguments))completion;

+ (void)generateSQLForUpdatingArticle:(PRArticle *)article completion:(void (^)(NSString *sql, NSArray *arguments))completion;

@end
