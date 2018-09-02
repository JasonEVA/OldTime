//
//  SiteMessageModel.m
//  HMClient
//
//  Created by Dee on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SiteMessageModel.h"

@implementation SiteMessageModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.createTime = @"";
        self.doStatus = 0;
        self.doThing = @"";
        self.msgId = 0;
        self.msgTitle = @"";
        self.msgTypeId = 0;
        self.publishTime = @"";
        self.publishUser = 0;
        self.receiveUserName  =@"";
        self.status = 0;
        self.userId = 0;
        self.userName = @"";
        self.deviceToken = @"";
        self.msgContent = @"";
        self.reviewTime = @"";
        self.reviewUser = @"";
    }
    return self;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
        
        if ([oldValue isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    
    return oldValue;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"createTime"          :@"createTime",
             @"doStatus"            :@"doStatus",
             @"doThing"             :@"doThing",
             @"msgId"               :@"msgId",
             @"msgTitle"            :@"msgTitle",
             @"msgTypeId"           :@"msgTypeId",
             @"publishTime"         :@"publishTime",
             @"publishUser"         :@"publishUser",
             @"receiveUserName"     :@"publishUser",
             @"status"              :@"status",
             @"userId"              :@"userId",
             @"userName"            :@"userName"
             };
}


@end
