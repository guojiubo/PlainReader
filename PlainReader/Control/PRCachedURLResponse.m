//
//  PRCachedURLResponse.m
//  PlainReader
//
//  Created by guojiubo on 14-5-8.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRCachedURLResponse.h"

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";

@implementation PRCachedURLResponse

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _data = [aDecoder decodeObjectForKey:kDataKey];
        _response = [aDecoder decodeObjectForKey:kResponseKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.data forKey:kDataKey];
    [aCoder encodeObject:self.response forKey:kResponseKey];
}

@end
