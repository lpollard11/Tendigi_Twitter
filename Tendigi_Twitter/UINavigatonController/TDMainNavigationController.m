//
//  TDMainNavigationController.m
//  Tendigi_Twitter
//
//  Created by Lee Pollard on 4/23/15.
//  Copyright (c) 2015 Tendigi. All rights reserved.
//

#import "TDMainNavigationController.h"
#import "TDMainTableViewController.h"





@interface TDMainNavigationController ()

@end

@implementation TDMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setViewControllers:@[[TDMainTableViewController new]]];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
