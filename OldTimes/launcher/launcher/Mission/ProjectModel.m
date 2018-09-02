//
//  ProjectModel.m
//  launcher
//
//  Created by William Zhang on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ProjectModel.h"
#import "NSDictionary+SafeManager.h"
#import "ContactPersonDetailInformationModel.h"

static NSString * const d_showId         = @"showId";
static NSString * const d_name           = @"name";
static NSString * const d_teamNumber     = @"teamNumber";
static NSString * const d_unFinishedTask = @"unFinishedTask";
static NSString * const d_allTask        = @"allTask";
static NSString * const d_members        = @"members";

static NSString * const d_memberName = @"memberName";
static NSString * const d_memberTrueName = @"memberTrueName";

@implementation ProjectModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.showId         = [dict valueStringForKey:d_showId];
        self.name           = [dict valueStringForKey:d_name];
        self.teamNumber     = [[dict valueNumberForKey:d_teamNumber] integerValue];
        self.unFinishedTask = [[dict valueNumberForKey:d_unFinishedTask] integerValue];
        self.taskCounts     = [[dict valueNumberForKey:d_allTask] integerValue];
        
        self.arrayMembers = [NSMutableArray array];
        NSArray *members = [dict valueArrayForKey:d_members];
        for (NSDictionary *member in members) {
            if (!member) {
                continue;
            }
            
            NSString *showId = [member valueStringForKey:d_memberName];
            NSString *name   = [member valueStringForKey:d_memberTrueName];
            ContactPersonDetailInformationModel *model = [ContactPersonDetailInformationModel new];
            model.show_id = showId;
            model.u_true_name = name;
            !model ?: [self.arrayMembers addObject:model];
        }
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name count:(NSInteger)count {
    self = [super init];
    if (self) {
        self.name = name;
        self.taskCounts = count;
        self.arrayMembers = [NSMutableArray array];
    }
    return self;
}

- (NSString *)taskCountsString {
    if (self.taskCounts < 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%ld", self.taskCounts];
}

- (BOOL)isEqual:(id)object {
    return (
            [object isKindOfClass:[ProjectModel class]] &&
            [[object name] isEqualToString:[self name]]
            );
}

- (NSString *)createUser
{
    if (!_createUser)
    {
        _createUser = @"";
    }
    return _createUser;
}
@end
