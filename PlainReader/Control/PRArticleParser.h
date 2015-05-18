//
//  PRParser.h
//  PlainReader
//
//  Created by guojiubo on 14-5-10.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRArticle.h"

extern NSString *const XPathQueryArticleImages;

@interface PRArticleParser : NSObject

+ (void)parseArticle:(PRArticle *)article hpple:(TFHpple *)hpple;

@end
