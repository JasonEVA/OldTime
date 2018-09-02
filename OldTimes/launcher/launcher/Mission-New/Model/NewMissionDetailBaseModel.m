//
//  NewMissionDetailBaseModel.m
//  launcher
//
//  Created by jasonwang on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionDetailBaseModel.h"
#import "NSDictionary+SafeManager.h"

@implementation NewMissionDetailBaseModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _showId = [dic valueStringForKey:@"showId"];
        _title = [dic valueStringForKey:@"tTitle"];
        _startTime = [[dic valueStringForKey:@"tStartTime"] longLongValue];
        _endTime = [[dic valueStringForKey:@"tEndTime"] longLongValue];
        _userName = [dic valueStringForKey:@"tUser"];
        _userTrueName = [dic valueStringForKey:@"tUserName"];
        NSString *priorityString = [dic valueStringForKey:@"tPriority"];
        _priority = [WhiteBoradStatusType getMissionPriority:priorityString];
        _remindTime = [[dic valueStringForKey:@"tRemindTime"] longLongValue];
        _createUser = [dic valueStringForKey:@"createUser"];
        _createUserName = [dic valueStringForKey:@"createUserName"];
        _isStartTimeAllDay = [[dic valueStringForKey:@"isStartTimeAllDay"] intValue];
        _isEndTimeAllDay = [[dic valueStringForKey:@"isEndTimeAllDay"] intValue];
        NSString *type = [dic valueForKey:@"sType"];
        _type = [WhiteBoradStatusType getWhiteBoardStyle:type];
        _isAnnex = [[dic valueStringForKey:@"tIsAnnex"] intValue];
        _isComment = [[dic valueStringForKey:@"tIsComment"] intValue];
    }
    return self;
}

- (NSMutableArray *)attachMentArray {
    if (!_attachMentArray) {
        _attachMentArray = [NSMutableArray array];
    }
    return _attachMentArray;
}

- (NSArray *)userName
{
    if (!_userName) {
        _userName = [NSArray new];
    }
    return _userName;
}

- (NSArray *)userTrueName
{
    if (!_userTrueName) {
        _userTrueName = [NSArray new];
    }
    return _userTrueName;
}
@end
