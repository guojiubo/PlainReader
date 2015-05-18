//
//  PREmoticonParser.m
//  PlainReader
//
//  Created by guojiubo on 14-6-28.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PREmoticonParser.h"
#import "PREmoticon.h"

@implementation PREmoticonParser

+ (NSDictionary *)emoticonImageDictionary
{
    static NSDictionary *_dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dict = @{@"爱心":@"01",
                  @"汗":@"02",
                  @"黑":@"03",
                  @"加班":@"04",
                  @"贱笑":@"05",
                  @"惊讶":@"06",
                  @"抠鼻":@"07",
                  @"哭":@"08",
                  @"喷":@"09",
                  @"沙发":@"10",
                  @"生气":@"11",
                  @"双负五":@"12",
                  @"笑":@"13",
                  @"晕":@"14",};
    });
    return _dict;
}

+ (NSRegularExpression *)emoticonRegularExpression
{
    static NSRegularExpression *_reg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reg = [NSRegularExpression regularExpressionWithPattern:@"\\[s:(\\w+)\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return _reg;
}

+ (BOOL)isStringContainsEmoticon:(NSString *)string
{
    NSUInteger number = [[self emoticonRegularExpression] numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return number > 0;
}

+ (void)parseEmocationsFromString:(NSString *)string storeResults:(NSMutableArray *)results
{
    NSTextCheckingResult *match = [[self emoticonRegularExpression] firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    if (match.numberOfRanges > 0) {
        NSString *emoticonString = [string substringWithRange:[match rangeAtIndex:1]];
        NSString *imageName = [self emoticonImageDictionary][emoticonString];
        
        PREmoticon *emoticon = [[PREmoticon alloc] init];
        emoticon.location = [match rangeAtIndex:0].location;
        emoticon.imageName = imageName;
        [results insertObject:emoticon atIndex:0];
        
        string = [string stringByReplacingCharactersInRange:[match rangeAtIndex:0] withString:@""];
        [self parseEmocationsFromString:string storeResults:results];
    }
}

@end
