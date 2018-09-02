//
//  CareMessageTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CareMessageTask.h"
#import "VoiceHttpStep.h"

@implementation CareMessageTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"sendUserWordsSoundAndCare"];
    return postUrl;
}

@end


@interface CareVoiceUploadFileTask ()
{
    NSString* careVoicefileUrl;
}
@end

@implementation CareVoiceUploadFileTask

- (Step*) createFristStep
{
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        VoiceHttpStep* step = [[VoiceHttpStep alloc] initWithType:@"careVoiceFile" Params:dicParam VoiceData:self.extParam];
        return step;
    }
    return nil;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSString class]])
    {
        careVoicefileUrl = stepResult;
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        if (careVoicefileUrl) {
            [dicResult setValue:careVoicefileUrl forKey:@"careFileUrl"];
        }
        
        _taskResult = dicResult;
    }
}

@end
