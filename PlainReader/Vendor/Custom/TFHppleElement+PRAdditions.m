//
//  TFHppleElement+PRAdditions.m
//  PlainReader
//
//  Created by guojiubo on 14-3-31.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "TFHppleElement+PRAdditions.h"

@implementation TFHppleElement (PRAdditions)

- (TFHppleElement *)findFirstSubnodeWithClassName:(NSString *)className
{
    for (TFHppleElement *child in self.children) {
        if ([[child objectForKey:@"class"] isEqualToString:className]) {
            return child;
        }
        
        TFHppleElement *find = [child findFirstSubnodeWithClassName:className];
        if (find) {
            return find;
        }
    }
    return nil;
}

- (TFHppleElement *)findFirstSubnodeWithTagName:(NSString *)tagName
{
    for (TFHppleElement *child in self.children) {
        if ([[child tagName] isEqualToString:tagName]) {
            return child;
        }
        
        TFHppleElement *find = [child findFirstSubnodeWithTagName:tagName];
        if (find) {
            return find;
        }
    }
    return nil;
}

@end
