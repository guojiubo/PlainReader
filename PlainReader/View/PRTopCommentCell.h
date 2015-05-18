//
//  TopCommentCell.h
//  PlainReader
//
//  Created by guojiubo on 14-5-11.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRTableViewCell.h"

@interface PRTopCommentCell : PRTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *infoBorder;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) UIColor *contentTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *infoTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *articleTitleColor UI_APPEARANCE_SELECTOR;

- (void)configureForTableView:(UITableView *)tableView dataObject:(id)dataObject indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)cellHeightForTableView:(UITableView *)tableView dataObject:(id)dataObject;

@end
