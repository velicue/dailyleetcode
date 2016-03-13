//
//  ProblemListTableViewController.m
//  Daily LeetCode
//
//  Created by mandy on 16/3/9.
//  Copyright © 2016年 mandy. All rights reserved.
//

#import "ProblemListTableViewController.h"
#import "ProblemListTableViewCell.h"
#import "ProblemDetailTableViewController.h"
#import "Client.h"

@interface ProblemListTableViewController ()

@property Client *client;
@property NSArray *data;
@property NSNumber *problemId;

@end


@implementation ProblemListTableViewController

- (bool)shouldTimeOut:(int)depth forAPIAddr:(NSString *)APIAddr {
    return false;
}

- (void)receiveResponseObject:(id)responseObject forAPIAddr:(NSString *)APIAddr {
    self.data = [[NSUserDefaults standardUserDefaults] objectForKey:@"problems"];
    NSMutableArray *tempData = [((NSDictionary *)responseObject)[@"result"] mutableCopy];
    for (int i = 0; i < [tempData count]; i++) {
        tempData[i] = [tempData[i] mutableCopy];
        if (i >= [self.data count]) tempData[i][@"status"] = [NSNumber numberWithInt:0];
        else tempData[i][@"status"] = self.data[i][@"status"];
    }
    self.data = tempData;
    [[NSUserDefaults standardUserDefaults] setObject:self.data forKey:@"problems"];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)sendRequest {
    [self.client startRequest:@"http://leetcode-crawler.herokuapp.com/getProblemList"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [Client new];
    self.client.delegate = self;
    [self sendRequest];
    self.data = [[NSUserDefaults standardUserDefaults] objectForKey:@"problems"];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(sendRequest)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [self sendRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (NSString *)getStatus:(NSInteger) statusCode {
    if (statusCode == 0) {
        return @"";
    } else if (statusCode == 1) {
        return @"Today";
    } else if (statusCode == 2) {
        return @"Done";
    } else if (statusCode == 3) {
        return @"Seen";
    } else if (statusCode == 4) {
        return @"Delay";
    } else {
        return @"Hard";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProblemListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemListTableViewCell" forIndexPath:indexPath];
    
    cell.problemIdLabel.text = [self.data[indexPath.row][@"problem_id"] stringValue];
    cell.problemStatusLabel.text = [self getStatus:[self.data[indexPath.row][@"status"] integerValue]];
    cell.problemTitleLabel.text = self.data[indexPath.row][@"title"];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.problemId = self.data[indexPath.row][@"problem_id"];
    [self performSegueWithIdentifier:@"listShowProblemDetail" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ProblemDetailTableViewController *toVC = [segue destinationViewController];
    toVC.problemId = self.problemId;
}

@end
