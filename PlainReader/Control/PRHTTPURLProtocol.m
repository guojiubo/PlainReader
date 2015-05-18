//
//  PRURLProtocol.m
//  PlainReader
//
//  Created by guojiubo on 14-4-25.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRHTTPURLProtocol.h"
#import "PRCachedURLResponse.h"

static NSString *const PRHTTPURLProtocolHandledKey = @"PRHTTPURLProtocolHandledKey";

@interface PRHTTPURLProtocol ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation PRHTTPURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if (![request.URL.scheme isEqualToString:@"http"] && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:PRHTTPURLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSString *cacheKey = self.request.URL.absoluteString;
    PRCachedURLResponse *cachedResponse = [[CWObjectCache sharedCache] objectForKey:cacheKey];
    if (cachedResponse && cachedResponse.response && cachedResponse.data) {
        NSURLResponse *response = cachedResponse.response;
        NSData *data = cachedResponse.data;
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [newRequest setTimeoutInterval:15];
    [NSURLProtocol setProperty:@YES forKey:PRHTTPURLProtocolHandledKey inRequest:newRequest];
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    // cache image only
    NSString *MIMEType = [response.MIMEType lowercaseString];
    if (![MIMEType hasPrefix:@"image"]) {
        return;
    }
    
    self.data = [[NSMutableData alloc] init];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
    
    if (!self.response || [self.data length] == 0) {
        return;
    }
        
    PRCachedURLResponse *cache = [[PRCachedURLResponse alloc] init];
    cache.response = self.response;
    cache.data = self.data;
    [[CWObjectCache sharedCache] storeObject:cache forKey:[[self.request URL] absoluteString]];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response) {
        // simply consider redirect as an error
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorResourceUnavailable userInfo:nil];
        [[self client] URLProtocol:self didFailWithError:error];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

@end
