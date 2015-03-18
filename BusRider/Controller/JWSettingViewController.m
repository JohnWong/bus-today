//
//  JWSettingViewController.m
//  BusRider
//
//  Created by John Wong on 3/17/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWSettingViewController.h"
#import <MessageUI/MessageUI.h>
#import "JWViewUtil.h"
#import "JWWebViewController.h"
#import "Appirater.h"

@interface JWSettingViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation JWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, 22)];
    self.versionLabel.text = [self appVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    JWWebViewController *webController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"JWPushAbout"]) {
        webController.url = @"http://impress.sinaapp.com/bus/about.html";
    } else if ([segue.identifier isEqualToString:@"JWPushHelp"]) {
        webController.url = @"http://impress.sinaapp.com/bus/help.html";
    } else if ([segue.identifier isEqualToString:@"JWPushPrivacy"]) {
        webController.url = @"http://impress.sinaapp.com/bus/privacy.html";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    [Appirater rateApp];
                    break;
                case 1:
                    [self sendMail];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (void)sendMail {
    if (![MFMailComposeViewController canSendMail]) {
       [JWViewUtil showInfoWithMessage:@"不能发送邮件，请检查邮件设置"];
        return;
    }
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: [NSString stringWithFormat:@"[意见反馈]%@-%@", [self appName], [self appVersion]]];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"yellowxz@163.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"huangxiaozhe1988@gmail.com", nil];
    [mailPicker setCcRecipients:ccRecipients];
    [self presentViewController: mailPicker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            [JWViewUtil showSuccessWithMessage:@"发送成功"];
            break;
        case MFMailComposeResultFailed:
            [JWViewUtil showError:error];
            break;
        case MFMailComposeResultSaved:
            [JWViewUtil showInfoWithMessage:@"邮件已保存"];
            break;
        case MFMailComposeResultCancelled:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (NSString *)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)appName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return appName ?: [infoDictionary objectForKey:@"CFBundleName"];
}

@end
