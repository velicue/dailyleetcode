//
//  ProblemDetailTableViewController.m
//  Daily LeetCode
//
//  Created by mandy on 16/3/12.
//  Copyright © 2016年 mandy. All rights reserved.
//

#import "ProblemDetailTableViewController.h"
#import "ProblemListTableViewCell.h"
#import "DailyDescriptionTableViewCell.h"
#import "ProblemActionTableViewCell.h"

@interface ProblemDetailTableViewController ()

@property NSDictionary *data;

@end

@implementation ProblemDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *problemList = [[NSUserDefaults standardUserDefaults] objectForKey:@"problems"];
    for (int i = 0; i < [problemList count]; i++) {
        if ([problemList[i][@"problem_id"] integerValue] == [self.problemId integerValue]) {
            self.data = problemList[i];
            break;
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (section == 0) return 2;
    else if (section == 1) {
        if ([self.data[@"status"] integerValue] == 1) {
            //Revert to Unseen
            //Mark as Done
            //Mark as Hard
            //Mark as Postponed
            return 4;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ProblemListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemHeaderTableViewCell" forIndexPath:indexPath];
                
            cell.problemIdLabel.text = [self.data[@"problem_id"] stringValue];
            cell.problemStatusLabel.text = [self getStatus:[self.data[@"status"] integerValue]];
            cell.problemTitleLabel.text = self.data[@"title"];
            return cell;
        } else {
            DailyDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemDescriptionTableViewCell" forIndexPath:indexPath];
            cell.descriptionLabel.text = self.data[@"description"];
            return cell;
        }
    } else if (indexPath.section == 1) {
        ProblemActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemActionTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) cell.actionLabel.text = @"Mark this problem as 'Unseen'";
        if (indexPath.row == 1) cell.actionLabel.text = @"Mark this problem as 'Done'";
        if (indexPath.row == 2) cell.actionLabel.text = @"Mark this problem as 'Hard' and have a new one";
        if (indexPath.row == 3) cell.actionLabel.text = @"Mark this problem as 'Postponed' and have a new one";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemLinkTableViewCell" forIndexPath:indexPath];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 1 || indexPath.section != 0)
        return 44;
    else {
        NSDictionary *attributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:12.0f]
                                     };
        CGRect rect = [self.data[@"description"] boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 32.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        NSLog(@"%@\n", self.data[@"description"]);
        NSLog(@"%f\n", rect.size.height);
        return ceil(rect.size.height + 16.0f);
    }
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
