//
//  JWWebViewController.m
//  BusRider
//
//  Created by John Wong on 3/18/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

#import "JWWebViewController.h"
#import "UINavigationController+SGProgress.h"


@interface JWWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation JWWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh:nil];
}

- (void)viewWillDisAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController cancelSGProgress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.navigationController finishSGProgress];
}


- (IBAction)refresh:(id)sender
{
    [self.webView stopLoading];
    self.navigationItem.title = @"加载中...";
    [self.navigationController showSGProgressWithDuration:5.0];
    NSURL *url = [NSURL URLWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
