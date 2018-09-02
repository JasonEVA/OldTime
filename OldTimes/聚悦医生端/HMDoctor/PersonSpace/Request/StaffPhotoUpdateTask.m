//
//  StaffPhotoUpdateTask.m
//  HMDoctor
//
//  Created by lkl on 16/7/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffPhotoUpdateTask.h"
#import "ImageHttpStep.h"
#import "JsonHttpStep.h"

typedef enum : NSUInteger {
    StaffPhotoPostIndex,
    StaffPhotoUpdateInfoIndex,
} StaffPhotoStepIndex;

@interface StaffPhotoUpdateTask ()
{
    NSString* photoUrl;
}
@end

@implementation StaffPhotoUpdateTask

- (Step*) createFristStep
{
    
    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc]initWithType:@"staffphoto" Params:dicParam ImageData:self.extParam];
        step.tag = StaffPhotoPostIndex;
        return step;
    }
    return nil;
    
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    switch (currentStep.tag)
    {
        case StaffPhotoPostIndex:
        {
            if ([stepResult isKindOfClass:[NSString class]])
            {
                photoUrl = stepResult;
            }
        }
            break;
        case StaffPhotoUpdateInfoIndex:
        {
            if ([stepResult isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* dicResp = [stepResult valueForKey:@"result"];
                StaffInfo* staff = [StaffInfo mj_objectWithKeyValues:dicResp];
                [[UserInfoHelper defaultHelper] saveStaffInfo:staff];
                //UserInfo* userInfo = [UserInfo mj_objectWithKeyValues:dicResp];
                //[[UserInfoHelper defaultHelper] saveUserInfo:userInfo];
                _taskResult = staff;
            }
        }
            break;
        default:
            break;
    }
}

- (Step*) createNextStep
{
    switch (currentStep.tag)
    {
        case StaffPhotoPostIndex:
        {
            //更新用户头像信息
            if (photoUrl && 0 < photoUrl.length)
            {
                NSString* postUrl = [ClientHelper postStaffServiceUrl:@"updateStaffUserInfo"];;
                if (postUrl)
                {
                    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
                    
                    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
                    if (curStaff)
                    {
                        [dicParam setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
                    }
                    [dicParam setValue:photoUrl forKey:@"imgUrl"];

                    JsonHttpStep* step = [[JsonHttpStep alloc]initWithUrl:postUrl Params:dicParam];
                    step.tag = StaffPhotoUpdateInfoIndex;
                    return step;
                }
                
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

@end
