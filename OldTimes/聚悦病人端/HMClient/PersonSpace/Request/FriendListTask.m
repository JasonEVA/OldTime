//
//  FriendListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FriendListTask.h"
#import "FriendInfo.h"

@implementation FriendListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getUserRelativeFriendList"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        NSArray* myConcern = [dicResp valueForKey:@"myConcern"];
        if (myConcern && [myConcern isKindOfClass:[NSArray class]])
        {
            NSMutableArray* myConcernFriends = [NSMutableArray array];
            for (NSDictionary* dicFriend in myConcern)
            {
                FriendInfo* friend = [FriendInfo mj_objectWithKeyValues:dicFriend];
                [myConcernFriends addObject:friend];
            }
            
            [dicResult setValue:myConcernFriends forKey:@"myConcern"];
        }
        
        NSArray* payAttentionToMe = [dicResp valueForKey:@"payAttentionToMe"];
        if (payAttentionToMe && payAttentionToMe)
        {
            NSMutableArray* payAttentionToMeFriends = [NSMutableArray array];
            for (NSDictionary* dicFriend in payAttentionToMe)
            {
                FriendInfo* friend = [FriendInfo mj_objectWithKeyValues:dicFriend];
                [friend setRelativeFriendName:friend.relationUserDet.userName];
                
                [payAttentionToMeFriends addObject:friend];
            }
            
            [dicResult setValue:payAttentionToMeFriends forKey:@"payAttentionToMe"];
        }
        _taskResult = dicResult;
        return;
    }
    
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
