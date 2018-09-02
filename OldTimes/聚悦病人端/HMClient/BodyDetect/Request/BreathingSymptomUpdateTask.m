//
//  BreathingSymptomUpdateTask.m
//  HMClient
//
//  Created by lkl on 16/7/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingSymptomUpdateTask.h"

@implementation BreathingSymptomUpdateTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"updateUserBreath"];
    return postUrl;
}

@end
