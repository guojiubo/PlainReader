//
//  CWActivityMonitor.h
//  PlainReader
//
//  Created by guojiubo on 10/22/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRActivityMonitor : NSObject

+ (instancetype)sharedMonitor;

- (void)start;

- (void)stop;

@end
