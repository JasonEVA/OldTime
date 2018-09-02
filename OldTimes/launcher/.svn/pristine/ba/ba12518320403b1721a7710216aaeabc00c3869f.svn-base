//
//  ApplyGetSendListModel.m
//  launcher
//
//  Created by Kyle He on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyGetSendListModel.h"
#import "NSDictionary+SafeManager.h"
static NSString  *const show_Id      = @"SHOW_ID";
static NSString  *const A_Title      = @"A_TITLE";
static NSString  *const T_Show_Id    = @"T_SHOW_ID";
static NSString  *const Create_Time  = @"CREATE_TIME";
static NSString  *const A_Status     = @"A_STATUS";
static NSString  *const LAST_UPDATE_TIME = @"LAST_UPDATE_TIME";
static NSString  *const IS_HAVEFILE  = @"HAS_FILE";
static NSString  *const IS_HAVECOMMENT  = @"HAS_COMMENT";
static NSString  *const t_showid     = @"T_SHOW_ID";

@implementation ApplyGetSendListModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.title = [dict valueStringForKey:A_Title];
        self.showID = [dict valueStringForKey:show_Id];
        self.T_SHOW_ID = [dict valueStringForKey:t_showid];
        long long createTime = [[dict objectForKey:Create_Time] longLongValue]/1000;
        self.createTime = [NSDate dateWithTimeIntervalSince1970:createTime];
        self.status  = [dict valueStringForKey:A_Status];
        self.LAST_UPDATE_TIME = [[dict valueNumberForKey:LAST_UPDATE_TIME] longLongValue];
        self.Unreadmsg = NO;
        self.IS_HAVEFILE  = [[dict valueNumberForKey:IS_HAVEFILE] intValue];
        self.IS_HAVECOMMENT = [[dict valueNumberForKey:IS_HAVECOMMENT] intValue];
        self.UnreadComment = NO;
        self.A_APPROVE_PATH = [dict valueStringForKey:@"A_APPROVE_PATH"];
    }
    return self;
}

@end
