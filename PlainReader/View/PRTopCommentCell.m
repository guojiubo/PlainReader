//
//  TopCommentCell.m
//  PlainReader
//
//  Created by guojiubo on 14-5-11.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRTopCommentCell.h"
#import "PRTopComment.h"

@implementation PRTopCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)configureForTableView:(UITableView *)tableView dataObject:(id)dataObject indexPath:(NSIndexPath *)indexPath
{
    self.backgroundColor = [UIColor pr_backgroundColor];
    
    PRTopComment *comment = (PRTopComment *)dataObject;
    [self.contentLabel setText:comment.content];
    
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds) - 50;
    self.infoLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds) - 50;
    
    NSString *info = [NSString stringWithFormat:@"来自%@的网友对新闻 %@ 的评论", comment.from, [comment.article title]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:info];
    NSRange range = [info rangeOfString:comment.article.title];
    
    if ([[PRAppSettings sharedSettings] isNightMode]) {
        [self.infoBorder setImage:[UIImage imageNamed:@"TopCommentBorderNight"]];
        [self.contentLabel setTextColor:CW_HEXColor(0xcfcfcf)];
        [attrString cw_setTextColor:CW_HEXColor(0xcfcfcf)];
        [attrString cw_setTextColor:[UIColor pr_blueColor] range:range];
    }
    else {
        [self.infoBorder setImage:[UIImage imageNamed:@"TopCommentBorderDay"]];
        [self.contentLabel setTextColor:CW_HEXColor(0x1f1f20)];
        [attrString cw_setTextColor:[UIColor whiteColor]];
        [attrString cw_setTextColor:CW_HEXColor(0x00316d) range:range];
    }
    self.infoLabel.attributedText = attrString;
}

+ (CGFloat)cellHeightForTableView:(UITableView *)tableView dataObject:(id)dataObject
{
    PRTopComment *comment = (PRTopComment *)dataObject;
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [tableView cw_width] - 50, 19)];
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.numberOfLines = 0;
        contentLabel.text = comment.content;
        [contentLabel sizeToFit];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [tableView cw_width] - 50, 16)];
        infoLabel.font = [UIFont systemFontOfSize:13];
        infoLabel.numberOfLines = 0;
        NSString *info = [NSString stringWithFormat:@"来自%@的网友对新闻 %@ 的评论", comment.from, [comment.article title]];
        infoLabel.text = info;
        [infoLabel sizeToFit];
        
        comment.cellHeight = ceil([contentLabel cw_height] + [infoLabel cw_height] + 50.0);
    }
    else {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [tableView cw_width] - 50, 21)];
        contentLabel.font = [UIFont systemFontOfSize:18];
        contentLabel.numberOfLines = 0;
        contentLabel.text = comment.content;
        [contentLabel sizeToFit];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [tableView cw_width] - 50, 18)];
        infoLabel.font = [UIFont systemFontOfSize:15];
        infoLabel.numberOfLines = 0;
        NSString *info = [NSString stringWithFormat:@"来自%@的网友对新闻 %@ 的评论", comment.from, [comment.article title]];
        infoLabel.text = info;
        [infoLabel sizeToFit];
        
        comment.cellHeight = ceil([contentLabel cw_height] + [infoLabel cw_height] + 60.0);
    }
    
    return comment.cellHeight;
}

@end
