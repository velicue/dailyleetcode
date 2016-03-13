//
//  ProblemListTableViewCell.h
//  Daily LeetCode
//
//  Created by mandy on 16/3/9.
//  Copyright © 2016年 mandy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *problemIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemStatusLabel;

@end
