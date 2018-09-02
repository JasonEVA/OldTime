//
//  HMSendCareUploadImageRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSendCareUploadImageRequest.h"
#import "ImageHttpStep.h"

@implementation HMSendCareUploadImageRequest

- (Step*) createFristStep
{
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc] initWithType:@"usercare" Params:dicParam ImageData:self.extParam];
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
