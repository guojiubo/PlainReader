//
//  PRCachedURLResponse.h
//  PlainReader
//
//  Created by guojiubo on 14-5-8.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRCachedURLResponse : NSObject <NSCoding>

@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSData *data;

@end
