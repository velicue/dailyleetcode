//
//  Client.h
//  Daily LeetCode
//
//  Created by mandy on 16/3/10.
//  Copyright © 2016年 mandy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientDelegate.h"

@interface Client : NSObject
@property (retain) id <ClientDelegate> delegate;
- (void)startRequest:(NSString *)APIAddr;

@end
