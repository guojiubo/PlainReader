//
//  PRCustomURLProtocol.m
//  PlainReader
//
//  Created by guo on 5/16/15.
//  Copyright (c) 2015 GUOJIUBO. All rights reserved.
//

#import "PRCustomURLProtocol.h"
#import "PRCachedURLResponse.h"

static NSString *const PRCustomURLProtocolHandledKey = @"PRCustomURLProtocolHandledKey";
static NSString *const PRCustomURLProtocolSchema = @"plainreader";

@interface PRCustomURLProtocol ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation PRCustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if (![request.URL.scheme isEqualToString:PRCustomURLProtocolSchema]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:PRCustomURLProtocolHandledKey inRequest:request]) {
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
    // get the original request url which is wrapped in the form of
    // "plainreader://abc.def?original-request-url"
    NSString *cacheKey = self.request.URL.query;
    PRCachedURLResponse *cachedResponse = [[CWObjectCache sharedCache] objectForKey:cacheKey];
    if (cachedResponse && cachedResponse.response && cachedResponse.data) {
        NSURLResponse *response = cachedResponse.response;
        NSData *data = cachedResponse.data;
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    
    if ([self.request.URL.absoluteString containsString:@"article.body.img"]) {
        UIImage *placeholder = [UIImage imageNamed:@"article_img_placeholder"];
        NSData *data = UIImagePNGRepresentation(placeholder);
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:cacheKey] MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:@"utf-8"];
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [newRequest setTimeoutInterval:15];
    [NSURLProtocol setProperty:@YES forKey:PRCustomURLProtocolHandledKey inRequest:newRequest];
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
