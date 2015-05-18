//
//  CWLogger.m
//  PlainReader
//
//  Created by guo on 10/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRLogger.h"

#ifdef DEBUG
const int ddLogLevel = LOG_FLAG_DEBUG | LOG_FLAG_ERROR;
#else
const int ddLogLevel = LOG_LEVEL_OFF;
#endif

@implementation PRLogger

+ (void)setup
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    /*
     * You may occasionally notice that colors don't work when you're debugging your app in the simulator. And you may also notice that your colors never work when debugging on the actual device. How do I fix it so it works everywhere, all the time?
     * In Xcode bring up the Scheme Editor (Product -> Edit Scheme...)
     * Select "Run" (on the left), and then the "Arguments" tab
     * Add a new Environment Variable named "XcodeColors", with a value of "YES"
     * see https://github.com/CocoaLumberjack/CocoaLumberjack/blob/master/Documentation/XcodeColors.md for detail.
     */
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor cyanColor] backgroundColor:nil forFlag:LOG_FLAG_DEBUG];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor brownColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
}

@end
