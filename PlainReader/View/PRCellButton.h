//
//  PRCellButton.h
//  PlainReader
//
//  Created by guo on 5/8/15.
//  Copyright (c) 2015 GUOJIUBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRCellButton : UIButton

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, strong) id userInfo;

@end
