//
//  PRCommentActionView.h
//  PlainReader
//
//  Created by guojiubo on 12/11/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRCellButton.h"
#import "PRComment.h"

@interface PRCommentActionView : UIView

@property (nonatomic, strong) PRCellButton *supportButton;
@property (nonatomic, strong) PRCellButton *opposeButton;
@property (nonatomic, strong) PRCellButton *replyButton;
@property (nonatomic, strong) PRComment *comment;

@end
