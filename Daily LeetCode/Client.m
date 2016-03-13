//
//  Client.m
//  Daily LeetCode
//
//  Created by mandy on 16/3/10.
//  Copyright © 2016年 mandy. All rights reserved.
//

#import "Client.h"
#import <AFNetworking/AFNetworking.h>

@implementation Client
- (void)startRequest:(NSString *)APIAddr {
    [self startRequest:APIAddr forDepth:0];
}

- (void)startRequest:(NSString *)APIAddr forDepth:(int)dep{
    if ([self.delegate shouldTimeOut:dep forAPIAddr:APIAddr]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:APIAddr];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [self.delegate receiveResponseObject:responseObject forAPIAddr:APIAddr];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self startRequest:APIAddr forDepth:dep + 1];
        });
    }];
}

@end

