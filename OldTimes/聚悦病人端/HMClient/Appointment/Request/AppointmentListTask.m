//
//  AppointmentListTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentListTask.h"
#import "AppointmentInfo.h"
#import "ImageHttpStep.h"
#import "JsonHttpStep.h"

@implementation AppointmentListTask

- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postAppointmetnServiceUrl:@"getMcAppoints"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstResp = [dicResp valueForKey:@"list"];
        NSMutableArray* appointItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicAppoint in lstResp)
            {
                AppointmentInfo* appointment = [AppointmentInfo mj_objectWithKeyValues:dicAppoint];
                [appointItems addObject:appointment];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:appointItems forKey:@"list"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        _taskResult = dicResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end



@interface SymptomImageListTask ()
{
    NSString* photoUrl;
}
@end

@implementation SymptomImageListTask

- (Step*) createFristStep
{
    
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc]initWithType:@"SymptomImageList" Params:dicParam ImageData:self.extParam];
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


