//
//  PRComment.m
//  PlainReader
//
//  Created by guojiubo on 14-5-11.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRComment.h"
#import "PREmoticonParser.h"

@interface PRComment ()

@property (nonatomic, copy) NSString *pureContent;
@property (nonatomic, assign) BOOL containsEmocaton;
@property (nonatomic, strong) NSMutableArray *emoticons;

@end

@implementation PRComment

+ (instancetype)instanceFromDictionary:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if ([dict count] == 0) {
        return nil;
    }
    
    // remove null
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    for (id key in [mutableDict allKeys]) {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSNull class]]) {
            [mutableDict removeObjectForKey:key];
        }
    }
    
    id instance = [[[self class] alloc] init];
    [instance configureAttributeFromDictionary:mutableDict];
    return instance;
}

- (void)configureAttributeFromDictionary:(NSDictionary *)commentDict
{
    self.cid = commentDict[@"tid"];
    self.aid = commentDict[@"sid"];
    self.userName = commentDict[@"name"];
    self.time = commentDict[@"date"];
    self.content = commentDict[@"comment"];
    self.support = [commentDict[@"score"] integerValue];
    self.oppose = [commentDict[@"reason"] integerValue];
    NSString *from = commentDict[@"host_name"];
    self.from = from.length > 0 ? from : @"艾泽拉斯";
    self.avatarUrl = commentDict[@"icon"];
    
    self.containsEmocaton = [PREmoticonParser isStringContainsEmoticon:self.content];
    if (self.containsEmocaton) {
        self.emoticons = [[NSMutableArray alloc] init];
        [PREmoticonParser parseEmocationsFromString:self.content storeResults:self.emoticons];
        self.content = [[PREmoticonParser emoticonRegularExpression] stringByReplacingMatchesInString:self.content options:0 range:NSMakeRange(0, [self.content length]) withTemplate:@""];
    }
}

@end
