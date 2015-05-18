//
//  PRAppearenceManager.h
//  PlainReader
//
//  Created by guo on 11/6/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRAppearanceManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;

@end
