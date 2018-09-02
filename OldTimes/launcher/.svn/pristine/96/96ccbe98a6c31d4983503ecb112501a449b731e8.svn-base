//
//  ProjectEditRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/11.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ProjectEditRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "ProjectModel.h"

static NSString * const d_showId  = @"showId";
static NSString * const d_name    = @"name";
static NSString * const d_members = @"members";

static const NSString *d_memberName     = @"memberName";
static const NSString *d_memberTrueName = @"memberTrueName";

@implementation ProjectEditRequest

- (NSString *)api { return @"/Task-Module/Task/ProjectEdit";}

- (void)editProjectShowId:(NSString *)showId name:(NSString *)projectName people:(NSArray *)people {
    self.params[d_showId] = showId;
    self.params[d_name]   = projectName;
    
    NSMutableArray *arrayPeople = [NSMutableArray array];
    for (ContactPersonDetailInformationModel *person in people) {
        NSDictionary *dictPerson = @{
                                     d_memberName:person.show_id,
                                     d_memberTrueName:person.u_true_name
                                     };
        [arrayPeople addObject:dictPerson];
    }
    
    self.params[d_members] = arrayPeople;
    [self requestData];
}

@end
