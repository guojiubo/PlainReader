//
//  PRTopComment.m
//  PlainReader
//
//  Created by guo on 10/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRTopComment.h"

@implementation PRTopComment

- (NSString *)hashValue
{
    if (!_hashValue) {
        _hashValue = [[NSString stringWithFormat:@"%@%@%@", self.content, self.from, [self.article articleId]] cw_md5];
    }
    return _hashValue;
}

@end
