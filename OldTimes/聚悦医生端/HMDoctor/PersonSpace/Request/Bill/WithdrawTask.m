//
//  WithdrawTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "WithdrawTask.h"

@implementation WithdrawTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserAccountServiceUrl:@"withdraw"];
    return postUrl;
}

@end
