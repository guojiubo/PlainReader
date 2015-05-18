//
//  PRArticle.m
//  PlainReader
//
//  Created by guo on 10/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRArticle.h"
#import "PRDatabase.h"
#import "PRStarredCache.h"
#import "PRArticleParser.h"

@interface PRArticle ()

@property (nonatomic, copy) NSString *formattedTime;
@property (nonatomic, strong) NSArray *imgSrcs;

@end

@implementation PRArticle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)formattedTime
{
    if (_formattedTime) {
        return _formattedTime;
    }
    
    if (!self.pubTime || [self.pubTime length] < 19) {
        return @"";
    }
    
    _formattedTime = [self.pubTime substringWithRange:NSMakeRange(5, 11)];
    return _formattedTime;
}

- (BOOL)isStarred
{
    return [[PRStarredCache sharedCache] isStarred:self];
}

- (NSArray *)imgSrcs
{
    if (!self.content) {
        return nil;
    }
    
    if (_imgSrcs) {
        return _imgSrcs;
    }
    
    NSData *contentData = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:contentData];
    NSArray *images = [hpple searchWithXPathQuery:XPathQueryArticleImages];
    NSMutableArray *imgSrcs = nil;
    
    for (TFHppleElement *img in images) {
        if (!imgSrcs) {
            imgSrcs = [[NSMutableArray alloc] init];
        }
        [imgSrcs addObject:[img objectForKey:@"src"]];
    }
    return imgSrcs;
}

- (NSString *)toHTML
{
    static NSString *const kTitlePlaceholder = @"<!-- title -->";
    static NSString *const kSourcePlaceholder = @"<!-- source -->";
    static NSString *const kTimePlaceholder = @"<!-- time -->";
    static NSString *const kSummaryPlaceholder = @"<!-- summary -->";
    static NSString *const kContentPlaceholder = @"<!-- content -->";
    static NSString *const kCSSPlaceholder = @"<!-- css -->";
    static NSString *const kOriginPlaceholder = @"<!-- origin -->";
    
    static NSString *htmlTemplate = nil;
    
    if (!htmlTemplate) {
        NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"article" withExtension:@"html"];
        htmlTemplate = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSString *html = htmlTemplate;
    
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    
    NSString *css;
    
    if ([settings isNightMode]) {
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"night" withExtension:@"css"];
        css = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
    }
    else {
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"day" withExtension:@"css"];
        css = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        switch (settings.fontSize) {
            case PRArticleFontSizeSmall:
                css = [css stringByAppendingString:@"h1{font-size:18px;}.content, summary {font-size: 15px;line-height:22px;}.source, .time{font-size: 11px;}"];
                break;
            case PRArticleFontSizeNormal:
                css = [css stringByAppendingString:@"h1{font-size:20px;}.content, summary {font-size: 17px;line-height:25px;}.source, .time{font-size: 13px;}"];
                break;
            case PRArticleFontSizeBig:
                css = [css stringByAppendingString:@"h1{font-size:24px;}.content, summary {font-size: 20px;line-height:29px;}.source, .time{font-size: 15px;}"];
                break;
                
            default:
                break;
        }
    }
    else {
        switch (settings.fontSize) {
            case PRArticleFontSizeSmall:
                css = [css stringByAppendingString:@"h1{font-size:28px;}.content, summary {font-size: 20px;line-height:30px;}.source, .time{font-size: 15px;}"];
                break;
            case PRArticleFontSizeNormal:
                css = [css stringByAppendingString:@"h1{font-size:36px;}.content, summary {font-size: 24px;line-height:36px;}.source, .time{font-size: 17px;}"];
                break;
            case PRArticleFontSizeBig:
                css = [css stringByAppendingString:@"h1{font-size:44px;}.content, summary {font-size: 32px;line-height:46px;}.source, .time{font-size: 20px;}"];
                break;
                
            default:
                break;
        }
    }
    
    if (settings.inclineSummary) {
        css = [css stringByAppendingString:@"summary {font-style: italic;}"];
    }

    html = [html stringByReplacingOccurrencesOfString:kCSSPlaceholder withString:css];
    if (self.title) {
        html = [html stringByReplacingOccurrencesOfString:kTitlePlaceholder withString:self.title];
    }
    if (self.source) {
        html = [html stringByReplacingOccurrencesOfString:kSourcePlaceholder withString:self.source];
    }
    if (self.pubTime) {
        html = [html stringByReplacingOccurrencesOfString:kTimePlaceholder withString:self.pubTime];
    }
    if (self.summary) {
        html = [html stringByReplacingOccurrencesOfString:kSummaryPlaceholder withString:self.summary];
    }
    if (self.content) {
        html = [html stringByReplacingOccurrencesOfString:kContentPlaceholder withString:self.content];
        
        if (settings.isImageWIFIOnly && ![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
            for (NSString *imgSrc in self.imgSrcs) {
                html = [html stringByReplacingOccurrencesOfString:imgSrc withString:[@"plainreader://article.body.img?" stringByAppendingString:imgSrc]];
            }
        }
    }
    html = [html stringByReplacingOccurrencesOfString:kOriginPlaceholder withString:[NSString stringWithFormat:@"http://www.cnbeta.com/articles/%@.htm", self.articleId]];
    return html;
}

@end
