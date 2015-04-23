//
//  TDWebViewController.m
//  Tendigi_Twitter
//
//  Created by Lee Pollard on 4/23/15.
//  Copyright (c) 2015 Tendigi. All rights reserved.
//

#import "TDWebViewController.h"





@interface TDWebViewController ()

@property (nonatomic, readonly) UIWebView* webView;
@property (nonatomic, readonly) CGRect webViewFrame;

@end





@implementation TDWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	_webView = [UIWebView new];
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
	[self.view addSubview:self.webView];
	
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.webView setFrame:self.webViewFrame];
}

#pragma mark - Frames
-(CGRect)webViewFrame
{
	return self.view.bounds;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
