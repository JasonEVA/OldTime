//
//  PersonServiceComplainListModel.m
//  HMClient
//
//  Created by Dee on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonServiceComplainListModel.h"

@implementation PersonServiceComplainListModel


- (instancetype)init
{
    if (self = [super init])
    {
        self.complaintContent       = @"";
        self.complaintObjectID      = 0;
        self.complaintType          = 0;
        self.complaintObjectName    = @"";
        self.createTime             = @"";
        self.replyContent           = @"";
        self.status                 = @"";
        self.userComlaintId         = @"";
        self.userID                 = 0;
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
             @"complaintContent"    :@"complaintCon",
             @"complaintObjectID"   :@"complaintObjectId",
             @"complaintObjectName" :@"complaintObjectName",
             @"complaintType"       :@"complaintType",
             @"createTime"          :@"createTime",
             @"replyContent"        :@"replyCon",
             @"status"              :@"status",
             @"replyTime"           :@"replyTime",
             @"replyUserID"         :@"replyUserId",
             @"userComlaintId"      :@"userComplaintId",
             @"userID"              :@"userId"
             };
}


@end
