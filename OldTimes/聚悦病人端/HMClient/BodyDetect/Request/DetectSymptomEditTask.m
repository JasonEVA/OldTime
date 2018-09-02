//
//  DetectSymptomEditTask.m
//  HMClient
//
//  Created by lkl on 2017/4/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DetectSymptomEditTask.h"

@implementation DetectSymptomEditTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"updateSymptomByTestDataId"];
    return postUrl;
}

@end
