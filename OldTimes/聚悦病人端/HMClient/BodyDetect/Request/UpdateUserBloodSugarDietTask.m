//
//  UpdateUserBloodSugarDietTask.m
//  HMClient
//
//  Created by lkl on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UpdateUserBloodSugarDietTask.h"
#import "ImageHttpStep.h"
#import "JsonHttpStep.h"


@implementation UpdateUserBloodSugarDietTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"updateUserBloodSugarDiet"];
    return postUrl;
}

@end


@interface UserBloodSugarImageUpdateTask ()
{
    NSString* photoUrl;
}
@end

@implementation UserBloodSugarImageUpdateTask

- (Step*) createFristStep
{
    
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc]initWithType:@"BloodSugarImage" Params:dicParam ImageData:self.extParam];
        //step.tag = UserPhotoPostIndex;
        return step;
    }
    return nil;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSString class]])
    {
        photoUrl = stepResult;

        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
            
        if (photoUrl)
        {
            [dicResult setValue:photoUrl forKey:@"picUrl"];
        }
            
        _taskResult = dicResult;
    }
}


@end