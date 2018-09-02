//
//  NewMissionDetailModel.m
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionDetailModel.h"
#import "NSDictionary+SafeManager.h"
#import "ContactPersonDetailInformationModel.h"

@implementation NewMissionDetailModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.showId = [dic valueStringForKey:@"showId"];
        self.title = [dic valueStringForKey:@"tTitle"];
        self.startTime = [[dic valueStringForKey:@"tStartTime"] longLongValue];
        self.endTime = [[dic valueStringForKey:@"tEndTime"] longLongValue];
        
        
        NSString *priorityString = [dic valueStringForKey:@"tPriority"];
        self.priority = [WhiteBoradStatusType getMissionPriority:priorityString];
        self.remindType = [[dic valueStringForKey:@"tRemindType"] intValue];
        self.remindTime = [[dic valueStringForKey:@"tRemindTime"] longLongValue];
        self.createUser = [dic valueStringForKey:@"createUser"];
        self.createUserName = [dic valueStringForKey:@"createUserName"];
        self.isStartTimeAllDay = [[dic valueStringForKey:@"isStartTimeAllDay"] intValue];
        self.isEndTimeAllDay = [[dic valueStringForKey:@"isEndTimeAllDay"] intValue];
        
        NSString *type = [dic valueForKey:@"sType"];
        self.type = [WhiteBoradStatusType getWhiteBoardStyle:type];
        
        self.isAnnex = [[dic valueStringForKey:@"tIsAnnex"] intValue];
        self.isComment = [[dic valueStringForKey:@"tIsComment"] intValue];
        _level = [[dic valueStringForKey:@"tLevel"] intValue];
        _parentTaskId = [dic valueStringForKey:@"tParentShowId"];
        _projectId = [dic valueStringForKey:@"pShowId"];
        _projectName = [dic valueStringForKey:@"pName"];
        _content = [dic valueStringForKey:@"tContent"];
        _lastUpdateTime = [[dic valueStringForKey:@"lastUpdateTime"] longLongValue];
        NSDictionary *dictPresent = [dic valueDictonaryForKey:@"parentTask"];
        _parentTask = [[NewMissionDetailBaseModel alloc] initWithDic:dictPresent];
        
        NSArray *arrayChild = [dic valueArrayForKey:@"childTasks"];
        self.childTasks = [NSMutableArray array];
        
        for (NSDictionary *dictChild in arrayChild) {
            if (!dictChild) {
                continue;
            }
            NewMissionDetailBaseModel *childModel = [[NewMissionDetailBaseModel alloc] initWithDic:dictChild];
            [self.childTasks addObject:childModel];
        }
        
        self.userName = [dic valueStringForKey:@"tUser"];
        self.userTrueName = [dic valueStringForKey:@"tUserName"];
        
        
    }
    return self;
}



@end