//
//  SettingsViewController.m
//  PlainReader
//
//  Created by guojiubo on 14-5-14.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRSettingsViewController.h"
#import "PRRefreshHeader.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "PRDatabase.h"
#import "PRAutoHamburgerButton.h"
#import "PRBrowserViewController.h"

@interface PRSettingsViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *prefetchSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *imageWIFIOnlySwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *fontSizeSegment;
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *cacheIndicator;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UISwitch *fastScrollSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *autoStarSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *inclineSummarySwitch;

@end

@implementation PRSettingsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    [self.prefetchSwitch setOn:settings.isPrefetchOnWIFI];
    [self.imageWIFIOnlySwitch setOn:settings.isImageWIFIOnly];
    [self.fontSizeSegment setSelectedSegmentIndex:settings.fontSize];
    [self.versionLabel setText:[UIApplication cw_version]];
    [self.fastScrollSwitch setOn:settings.articleFastScroll];
    [self.autoStarSwitch setOn:settings.autoStarCommented];
    [self.inclineSummarySwitch setOn:settings.inclineSummary];
}

- (void)menuButtonAction:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
        
    PRRefreshHeader *header = [[PRRefreshHeader alloc] init];
    [header setTranslatesAutoresizingMaskIntoConstraints:NO];
    header.title = @"设置";
    [[parent view] addSubview:header];
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    PRAutoHamburgerButton *menuButton = [PRAutoHamburgerButton button];
    [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setCenter:CGPointMake(CGRectGetWidth(menuView.bounds)/2, CGRectGetHeight(menuView.bounds)/2)];
    [menuView addSubview:menuButton];
    [header setLeftView:menuView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(header);
    [[parent view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:nil views:viewDict]];
    [[parent view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header(64)]" options:0 metrics:nil views:viewDict]];
    
    UIEdgeInsets insets = [self.tableView contentInset];
    insets.top += 64;
    [self.tableView setContentInset:insets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cacheSizeLabel setText:@""];
    [self.cacheIndicator startAnimating];
    [[CWObjectCache sharedCache] calculateCacheSize:^(unsigned long long size) {
        NSString *cacheSize = [NSString stringWithFormat:@"%.2fMB", size/1024.0/1024.0];
        [self.cacheSizeLabel setText:cacheSize];
        [self.cacheIndicator stopAnimating];
    }];
}

#pragma mark - Actions

- (IBAction)switchValueChanged:(id)sender
{
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    settings.prefetchOnWIFI = [self.prefetchSwitch isOn];
    settings.imageWIFIOnly = [self.imageWIFIOnlySwitch isOn];
    settings.autoStarCommented = [self.autoStarSwitch isOn];
    settings.articleFastScroll = [self.fastScrollSwitch isOn];
    settings.inclineSummary = [self.inclineSummarySwitch isOn];
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    settings.fontSize = [self.fontSizeSegment selectedSegmentIndex];
}

- (void)clearCache
{
    [self.cacheSizeLabel setText:@""];
    [self.cacheIndicator startAnimating];
    
    [[CWObjectCache sharedCache] clearMemory];
    
    [[CWObjectCache sharedCache] clearDiskOnCompletion:^{
        [[PRDatabase sharedDatabase] clearExpiredArticles:^{
            [self.cacheSizeLabel setText:@"0.00MB"];
            [self.cacheIndicator stopAnimating];
        }];
    }];
}

- (void)contactMe
{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的手机还没有配置邮箱" message:@"请配置好邮箱后重试，你也可以通过其他渠道发送邮件到guojiubo@gmail.com来联系我" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    [vc setMailComposeDelegate:self];
    [vc setSubject:@"来自简阅"];
    [vc setToRecipients:@[@"guojiubo@gmail.com"]];
    [self.stackController presentViewController:vc animated:YES completion:nil];
}

- (void)about
{
    NSURL *URL = [NSURL URLWithString:@"http://cnbeta.cocoawind.com/about.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    PRBrowserViewController *vc = [[PRBrowserViewController alloc] init];
    vc.request = request;
    [self.stackController pushViewController:vc animated:YES];
}

#pragma mark - Mail callback

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[cell reuseIdentifier] isEqualToString:@"ClearCache"]) {
        [self clearCache];
        return;
    }
    
    if ([[cell reuseIdentifier] isEqualToString:@"ContactMe"]) {
        [self contactMe];
        return;
    }
    
    if ([[cell reuseIdentifier] isEqualToString:@"About"]) {
        [self about];
        return;
    }
}

@end
