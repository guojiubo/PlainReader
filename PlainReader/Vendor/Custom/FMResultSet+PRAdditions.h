//
//  FMResultSet+PRAdditions.h
//  PlainReader
//
//  Created by guo on 10/26/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "FMResultSet.h"
#import "PRArticle.h"
#import "PRTopComment.h"

@interface FMResultSet (PRAdditions)

- (NSNumber *)numberForColumnName:(NSString *)columnName;

- (PRArticle *)toArticle;

- (PRArticle *)toRealtimeArticle;

- (PRArticle *)toTopCommentArticle;

- (PRTopComment *)toTopComment;

@end
