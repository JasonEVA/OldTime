//
//  NutritionImageUploadTask.m
//  HMClient
//
//  Created by lkl on 2017/8/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NutritionImageUploadTask.h"
#import "ImageHttpStep.h"
#import "ClientHelper.h"

@interface NutritionImageUploadTask ()
{
    NSString* photoUrl;
}
@end

@implementation NutritionImageUploadTask

- (Step*) createFristStep
{
    
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc]initWithType:@"NutritionImage" Params:dicParam ImageData:self.extParam];
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
