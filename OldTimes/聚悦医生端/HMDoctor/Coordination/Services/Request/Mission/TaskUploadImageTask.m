//
//  TaskUploadImageTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "TaskUploadImageTask.h"
#import "ImageHttpStep.h"

@implementation TaskUploadImageTask

- (Step*) createFristStep
{
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc] initWithType:@"worktask" Params:dicParam ImageData:self.extParam];
        return step;
    }
    return nil;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSString class]])
    {
         _taskResult = stepResult;
    }
}

@end
