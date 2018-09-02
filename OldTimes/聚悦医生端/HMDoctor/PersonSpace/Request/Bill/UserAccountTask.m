//
//  UserAccountTask.m
//  HMDoctor
//
//  Created by lkl on 16/7/1.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserAccountTask.h"

@implementation UserAccountTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserAccountServiceUrl:@"getUserAccount"];
    return postUrl;
}


@end
