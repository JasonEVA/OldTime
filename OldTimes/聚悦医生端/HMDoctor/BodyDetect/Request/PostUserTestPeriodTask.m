//
//  PostUserTestPeriodTask.m
//  HMClient
//
//  Created by lkl on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PostUserTestPeriodTask.h"

@implementation PostUserTestPeriodTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"getUserTestDataKpi"];
    return postUrl;
}


@end
