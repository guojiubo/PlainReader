//
//  ArticleCell.m
//  PlainReader
//
//  Created by guojiubo on 14-3-28.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRArticleCell.h"
#import "PRCachedURLResponse.h"
#import "PRArticleParser.h"
#import "PRDatabase.h"

#define SECONDS_A_MINUTE    60
#define SECONDS_A_HOUR      (60 * 60)
#define SECONDS_A_DAY       (60 * 60 * 24)

@interface PRArticleCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *cover;
@property (nonatomic, weak) IBOutlet UIImageView *commentCountIcon;
@property (nonatomic, weak) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, weak) IBOutlet ArticleCellStarView *starView;
@property (nonatomic, weak) IBOutlet UIImageView *blueCycle;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, weak) IBOutlet UIImageView *timeIcon;
@property (nonatomic, weak) IBOutlet UIView *topContentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSLayoutConstraint *topContentViewCenterXConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *starViewRightConstraint;

@end

@implementation PRArticleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [[self.cover layer] setMasksToBounds:YES];
    [[self.cover layer] setCornerRadius:[self.cover cw_width]/2];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    self.panGestureRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:self.panGestureRecognizer];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.topContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.topContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.topContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    self.topContentViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.topContentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.contentView addConstraint:self.topContentViewCenterXConstraint];
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.topContentViewCenterXConstraint pop_removeAllAnimations];
        [self.starViewRightConstraint pop_removeAllAnimations];
        
        self.starView.hidden = NO;
        [self.starView setStarred:!self.article.isStarred];
        
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.contentView];

        translation.x = MIN(0, translation.x);

        self.topContentViewCenterXConstraint.constant = translation.x;
        
        translation.x = MAX(-80, translation.x);
        self.starViewRightConstraint.constant = -(80 + translation.x);
        
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        spring.toValue = @(0);
        spring.springBounciness = 8.0f;
        
        if (CGRectGetMaxX(self.starView.frame) <= CGRectGetWidth(self.bounds)) {
            [spring setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
                [self restoreStarView];
            }];
            
            if (self.article.isStarred) {
                [[PRDatabase sharedDatabase] unstarArticle:self.article];
            }
            else {
                [[PRDatabase sharedDatabase] starArticle:self.article];
            }
            
            self.timeIcon.image = self.article.isStarred ? [UIImage imageNamed:@"ArticleCellStarSmall"] : [UIImage imageNamed:@"article_time"];
        }
        else {
            [self restoreStarView];
        }
        
        [self.topContentViewCenterXConstraint pop_addAnimation:spring forKey:@"restore_top_view"];
    }
}

- (void)restoreStarView
{
    POPSpringAnimation *basic = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    basic.toValue = @(-80);
    basic.springBounciness = 8.0f;
    [basic setCompletionBlock:^(POPAnimation *a, BOOL f) {
        self.starView.hidden = YES;
    }];
    [self.starViewRightConstraint pop_addAnimation:basic forKey:@"restore_star_view"];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer != self.panGestureRecognizer) {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
    
    CGPoint translation = [gestureRecognizer translationInView:self.superview];
    NSLog(@"translation x: %f, y: %f", translation.x, translation.y);
    if (translation.x > 0 || fabs(translation.y) > 2.0f) {
        return NO;
    }
    return fabs(translation.y) <= fabs(translation.x);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.topContentViewCenterXConstraint pop_removeAllAnimations];
    [self.starViewRightConstraint pop_removeAllAnimations];
    [self.blueCycle pop_removeAllAnimations];
    
    if (self.queue) {
        [self.queue cancelAllOperations];
        self.queue = nil;
    }
}

- (void)setArticle:(PRArticle *)article
{
    _article = article;
    
    self.backgroundColor = [UIColor pr_backgroundColor];
    
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    if (settings.isNightMode) {
        [self.titleLabel setTextColor:[article.read boolValue] ? CW_HEXColor(0x818181) : CW_HEXColor(0xcfcfcf)];
    }
    else {
        [self.titleLabel setTextColor:[article.read boolValue] ? CW_HEXColor(0x818181) : CW_HEXColor(0x1f1f20)];
    }
    [self.titleLabel setText:article.title];
    self.timeIcon.image = article.isStarred ? [UIImage imageNamed:@"ArticleCellStarSmall"] : [UIImage imageNamed:@"article_time"];
    
    [self refreshPubtimeDisplay];
    [self refreshCacheStatusDisplay];
    
    if (article.thumb) {
        if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi] || !settings.isImageWIFIOnly) {
            [self.cover setImageWithURL:[NSURL URLWithString:article.thumb] placeholderImage:[UIImage imageNamed:@"article_cover_placeholder"]];
        }
        else {
            NSString *thumb = [@"plainreader://article.thumbnail?" stringByAppendingString:article.thumb];
            [self.cover setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage imageNamed:@"article_cover_placeholder"]];
        }
    }
    else {
        self.cover.image = [UIImage imageNamed:@"article_cover_placeholder"];
    }
    
    [self downloadArticle:article];
}

- (void)refreshPubtimeDisplay
{
    if (self.article.pubTime) {
        [self.timeIcon setHidden:NO];
        [self.timeLabel setHidden:NO];
        [self.commentCountLabel setHidden:NO];
        [self.timeLabel setTextColor:CW_HEXColor(0x818181)];
        [self.timeLabel setText:self.article.formattedTime];
        
        [self.commentCountLabel setTextColor:CW_HEXColor(0x818181)];
        
        [self.commentCountIcon setHidden:!self.article.commentCount];
        [self.commentCountLabel setText:[self.article.commentCount stringValue]];
    }
    else {
        [self.timeIcon setHidden:YES];
        [self.timeLabel setHidden:YES];
        [self.commentCountIcon setHidden:YES];
        [self.commentCountLabel setHidden:YES];
    }
}

- (void)refreshCacheStatusDisplay
{
    [self.blueCycle setAlpha:0];
    if ([self.article.cacheStatus integerValue] == PRArticleCacheStatusCached) {
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        animation.toValue = @1;
        animation.springBounciness = 8.0f;
        [self.blueCycle pop_addAnimation:animation forKey:@"show"];
    }
}

- (void)downloadArticle:(PRArticle *)article
{
    if ([article.cacheStatus integerValue] != PRArticleCacheStatusNone) {
        return;
    }
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        return;
    }
    
    if (![[PRAppSettings sharedSettings] isPrefetchOnWIFI]) {
        return;
    }
    
    if (self.queue) {
        [self.queue cancelAllOperations];
        self.queue = nil;
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"CellArticleDownloadQueue";
    queue.maxConcurrentOperationCount = 1;
    self.queue = queue;
    
    NSString *api = [NSString stringWithFormat:@"http://www.cnbeta.com/articles/%@.htm", article.articleId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:api] cachePolicy:0 timeoutInterval:15.0];
    
    AFHTTPRequestOperation *articleOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [articleOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:operation.responseData];
            [PRArticleParser parseArticle:article hpple:hpple];
            
            // Got the content means article success cached
            article.cacheStatus = @(PRArticleCacheStatusCached);
            [[PRDatabase sharedDatabase] storeArticle:article];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self refreshCacheStatusDisplay];
                [self refreshPubtimeDisplay];
            });
            
            // 自动下载所有图片
            NSArray *imgSrcs = article.imgSrcs;
            for (int i = 0; i < imgSrcs.count; i++) {
                NSString *imgSrc = imgSrcs[i];
                if (i == 0 && !article.thumb) {
                    article.thumb = imgSrc;
                }
                
                NSURLRequest *imgRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imgSrc] cachePolicy:0 timeoutInterval:15.0];
                AFHTTPRequestOperation *imgOperation = [[AFHTTPRequestOperation alloc] initWithRequest:imgRequest];
                [self.queue addOperation:imgOperation];
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == NSURLErrorCancelled) {
            return;
        }
        
        DDLogError(@"%@", error);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            article.cacheStatus = @(PRArticleCacheStatusFailed);
            [[PRDatabase sharedDatabase] storeArticle:article];
        });
    }];
    [self.queue addOperation:articleOperation];
}

@end
