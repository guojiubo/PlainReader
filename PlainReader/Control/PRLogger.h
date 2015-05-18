//
//  CWLogger.h
//  PlainReader
//
//  Created by guo on 10/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDLog.h>
#import <DDASLLogger.h>
#import <DDTTYLogger.h>

extern const int ddLogLevel;

@interface PRLogger : NSObject

+ (void)setup;

@end
