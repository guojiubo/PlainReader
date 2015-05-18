//
//  PREmoticon.h
//  PlainReader
//
//  Created by guojiubo on 14-6-29.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PREmoticon : NSObject

@property (nonatomic, assign) NSUInteger location;
@property (nonatomic, copy) NSString *imageName;

- (NSData *)imageData;

@end
