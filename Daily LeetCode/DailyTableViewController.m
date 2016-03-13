//
//  DailyTableViewController.m
//  Daily LeetCode
//
//  Created by mandy on 16/3/12.
//  Copyright © 2016年 mandy. All rights reserved.
//

#import "DailyTableViewController.h"
#import "ProblemListTableViewCell.h"
#import "DailyDescriptionTableViewCell.h"
#import "ProblemDetailTableViewController.h"
#include <stdlib.h>


@interface DailyTableViewController ()

@property NSArray *data;
@property NSNumber *problemId;

@end

@implementation DailyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSDate *)dateOnly: (NSDate *)date {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    return [calendar dateFromComponents:components];
}

- (BOOL)isToday: (NSDate *)prevDate {
    NSDate *today = [NSDate date];
    NSDate *prevDateOnly = [self dateOnly: prevDate];
    NSDate *todayDateOnly = [self dateOnly: today];
    if ([prevDateOnly compare:todayDateOnly] == NSOrderedSame)
        return true;
    else
        return false;
}

- (void)viewDidAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"history"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject: [[NSMutableArray alloc] init] forKey:@"history"];
    }
    
    NSInteger problemsPerDay = 3;
    
    //NSMutableArray *history = [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
    NSMutableArray *history = [[NSMutableArray alloc] init];
    if ([history count] == 0 || ![self isToday: history[[history count] - 1][@"date"]]) {
        if ([history count] == 0) history = [[NSMutableArray alloc] init];
        NSMutableDictionary *historyToday = [[NSMutableDictionary alloc] init];
        [historyToday setObject:[NSDate date] forKey:@"date"];
        NSMutableArray *todayProblems = [[NSMutableArray alloc] init];
        NSMutableArray *problemList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"problems"] mutableCopy];
        NSMutableArray *problemsAvailable = [[NSMutableArray alloc] init];
        for (int i = 0; i < [problemList count]; i++) {
            if ([problemList[i][@"status"] integerValue] == 4) {
                [todayProblems addObject:problemList[i]];
            }
            if ([problemList[i][@"status"] integerValue] == 0 || [problemList[i][@"status"] integerValue] == 5) {
                [problemsAvailable addObject:problemList[i]];
            }
        }
        for (int i = 0; problemsPerDay > [todayProblems count]; i++) {
            int index = arc4random_uniform([problemsAvailable count]);
            [todayProblems addObject:problemsAvailable[index]];
            [problemsAvailable removeObjectAtIndex:index];
        }
        for (int i = 0; i < [problemList count]; i++) {
            problemList[i] = [problemList[i] mutableCopy];
            if ([problemList[i][@"status"] integerValue] == 1)
                 problemList[i][@"status"] = [NSNumber numberWithInt:5];
        }
        for (int i = 0; i < problemsPerDay; i++) {
            int index = 0;
            for (int j = 0; j < [problemList count]; j++) {
                if ([problemList[j][@"problem_id"] integerValue] == [todayProblems[i][@"problem_id"] integerValue]) {
                    index = j;
                    break;
                }
            }
            problemList[index][@"status"] = [NSNumber numberWithInt:1];
        }
        [[NSUserDefaults standardUserDefaults] setObject:problemList forKey:@"problems"];
        historyToday[@"problems"] = todayProblems;
        [history addObject:historyToday];
        [[NSUserDefaults standardUserDefaults] setObject:history forKey:@"history"];
    }
    self.data = history[[history count] - 1][@"problems"];
    [self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProblemListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dailyHeaderTableViewCell" forIndexPath:indexPath];
    
        cell.problemIdLabel.text = [self.data[indexPath.section][@"problem_id"] stringValue];
        cell.problemStatusLabel.text = @"";
        cell.problemTitleLabel.text = self.data[indexPath.section][@"title"];
        if ([self.data[indexPath.section][@"status"] integerValue] == 2)
            cell.problemStatusLabel.text = @"Done";
        return cell;
    } else {
        DailyDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dailyDescriptionTableViewCell" forIndexPath:indexPath];
        cell.descriptionLabel.text = self.data[indexPath.section][@"description"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 44;
    else {
        NSDictionary *attributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:12.0f]
                                     };
        CGRect rect = [self.data[indexPath.section][@"description"] boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 32.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        NSLog(@"%@\n", self.data[indexPath.section][@"description"]);
        NSLog(@"%f\n", rect.size.height);
        return ceil(rect.size.height + 16.0f);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.problemId = self.data[indexPath.section][@"problem_id"];
        [self performSegueWithIdentifier:@"dailyShowProblemDetail" sender:self];
    }
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
