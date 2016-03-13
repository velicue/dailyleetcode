//
//  ClientDelegate.h
//  Daily LeetCode
//
//  Created by mandy on 16/3/10.
//  Copyright © 2016年 mandy. All rights reserved.
//

#ifndef ClientDelegate_h
#define ClientDelegate_h
#import <Foundation/Foundation.h>

@protocol ClientDelegate <NSObject>

- (void)receiveResponseObject:(id)responseObject forAPIAddr:(NSString *)APIAddr;
- (BOOL)shouldTimeOut:(int)depth forAPIAddr:(NSString *)APIAddr;

@end


#endif /* ClientDelegate_h */
