//
//  TFHppleElement+PRAdditions.h
//  PlainReader
//
//  Created by guojiubo on 14-3-31.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "TFHppleElement.h"

@interface TFHppleElement (PRAdditions)

- (TFHppleElement *)findFirstSubnodeWithClassName:(NSString *)className;

- (TFHppleElement *)findFirstSubnodeWithTagName:(NSString *)tagName;

@end
