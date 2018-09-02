//
//  UploadFoodImageTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UploadFoodImageTask.h"
#import "ImageHttpStep.h"
#import "HttpTaskProgressDelegate.h"

@implementation AppendDietRecordTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"addUserDietRecord"];
    return postUrl;
}

@end

@interface UploadFoodImageTask ()
<HttpTaskProgressDelegate>

@end

@implementation UploadFoodImageTask

- (Step*) createFristStep
{
    
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc]initWithType:@"food" Params:dicParam ImageData:self.extParam];
        //step.tag = UserPhotoPostIndex;
        [step setProgressDelegate:self];
        return step;
    }
    return nil;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSString class]])
    {
        NSString* photoUrl = stepResult;
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        if (photoUrl)
        {
            [dicResult setValue:photoUrl forKey:@"picUrl"];
        }
        
        _taskResult = dicResult;
    }
}

- (void) postPorgress:(NSInteger) postUnit Total:(NSInteger) totalUnit
{
    [self postTaskProgress:postUnit Total:totalUnit];
}
@end
