//
//  PREmoticonParser.h
//  PlainReader
//
//  Created by guojiubo on 14-6-28.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PREmoticonParser : NSObject

+ (NSDictionary *)emoticonImageDictionary;

+ (NSRegularExpression *)emoticonRegularExpression;

+ (BOOL)isStringContainsEmoticon:(NSString *)string;

+ (void)parseEmocationsFromString:(NSString *)string storeResults:(NSMutableArray *)results;

@end
