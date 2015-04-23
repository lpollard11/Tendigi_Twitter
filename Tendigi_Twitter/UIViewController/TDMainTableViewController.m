//
//  TDMainTableViewController.m
//  Tendigi_Twitter
//
//  Created by Lee Pollard on 4/23/15.
//  Copyright (c) 2015 Tendigi. All rights reserved.
//

#import "TDMainTableViewController.h"
#import <TwitterKit/TwitterKit.h>





static NSString * const TweetTableReuseIdentifier = @"TweetCell";





@interface TDMainTableViewController () <TWTRTweetViewDelegate>

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) NSMutableArray *loadedTweetIDs;
-(void)loadTweets;
-(void)guestLogin;
-(void)loadWithTweetIDs;

@end





@implementation TDMainTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//	NSArray *tweetIDs = @[@"20", // @jack's first Tweet
	//						  @"510908133917487104" // our favorite Bike tweet
	//						  ];
	
	self.tableView.estimatedRowHeight = 150;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	self.tableView.allowsSelection = NO;
	[self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
	
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	
	_loadedTweetIDs = [NSMutableArray new];
	
	[self guestLogin];
}

#pragma mark - Load Tweets
-(void)guestLogin
{
	[[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error)
	 {
		 if (guestSession)
		 {
			 [self loadTweets];
		 }
		 else
		 {
			 NSLog(@"error: %@", [error localizedDescription]);
		 }
	 }];
}

-(void)loadTweets
{
	NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/statuses/lookup.json";
	NSDictionary *params = @{@"id" : @"510908133917487104"};
	NSError *clientError;
	NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
							 URLRequestWithMethod:@"GET"
							 URL:statusesShowEndpoint
							 parameters:params
							 error:&clientError];
 
	if (request) {
		[[[Twitter sharedInstance] APIClient]
		 sendTwitterRequest:request
		 completion:^(NSURLResponse *response,
					  NSData *data,
					  NSError *connectionError) {
			 
			 
			 if (data) {
				 // handle the response data e.g.
				 NSError *jsonError;
				 NSArray *json = [NSJSONSerialization
								  JSONObjectWithData:data
								  options:0
								  error:&jsonError];
				 
				 NSDictionary *json1 = [json objectAtIndex:0];
				 if ([json1 isKindOfClass:[NSDictionary class]])
				 {
					 TWTRTweet *tweet = [[TWTRTweet alloc] initWithJSONDictionary:json1];
					 if (tweet)
					 {
						 NSString *tweetID = tweet.tweetID;
						 [self.loadedTweetIDs addObject:tweetID];
						 [self loadWithTweetIDs];
					 }
				 }
			 }
			 else {
				 NSLog(@"Error: %@", connectionError);
			 }
		 }];
	}
	else {
		NSLog(@"Error: %@", clientError);
	}
}

-(void)loadWithTweetIDs
{
	__weak typeof(self) weakSelf = self;
	[[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:self.loadedTweetIDs completion:^(NSArray *tweets, NSError *error) {
		if (tweets) {
			typeof(self) strongSelf = weakSelf;
			strongSelf.tweets = tweets;
			[strongSelf.tableView reloadData];
		} else {
			NSLog(@"Failed to load tweet: %@", [error localizedDescription]);
		}
	}];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TWTRTweet *tweet = self.tweets[indexPath.row];
 
	TWTRTweetTableViewCell *cell = (TWTRTweetTableViewCell *)
	
	[self.tableView dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
	
	[cell configureWithTweet:tweet];
	cell.tweetView.delegate = self;
 
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	TWTRTweet *tweet = self.tweets[indexPath.row];
 
	return [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
