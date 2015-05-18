//
//  PRURLCache.m
//  PlainReader
//
//  Created by guojiubo on 14-3-28.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRURLCache.h"
#import "PRCachedURLResponse.h"

@implementation PRURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    NSString *cacheKey = [request URL].absoluteString;
    PRCachedURLResponse *cachedResponse = [[CWObjectCache sharedCache] objectForKey:cacheKey];
    if (cachedResponse && cachedResponse.response && cachedResponse.data) {
        return [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data];;
    }
    
    return [super cachedResponseForRequest:request];
}

@end
