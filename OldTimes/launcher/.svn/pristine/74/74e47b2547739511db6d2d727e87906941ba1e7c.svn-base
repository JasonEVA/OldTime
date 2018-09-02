//
//  ProjectCreateRequest.m
//  launcher
//
//  Created by William Zhang on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ProjectCreateRequest.h"
#import "NSDictionary+SafeManager.h"
#import "ContactPersonDetailInformationModel.h"
#import "UnifiedUserInfoManager.h"

static const NSString *d_name    = @"name";
static const NSString *d_members = @"members";

static const NSString *d_memberName     = @"memberName";
static const NSString *d_memberTrueName = @"memberTrueName";

@implementation ProjectCreateResponse
@end

@implementation ProjectCreateRequest

- (void)createProject:(NSString *)projectName people:(NSArray *)people {
    self.params[d_name] = projectName;
    
    NSMutableArray *arrayPeople = [NSMutableArray array];
    for (ContactPersonDetailInformationModel *person in people) {
        NSDictionary *dictPerson = @{
                                     d_memberName:person.show_id,
                                     d_memberTrueName:person.u_true_name
                                     };
        [arrayPeople addObject:dictPerson];
    }
    NSDictionary *dictPerson = @{
                                 d_memberName:[[UnifiedUserInfoManager share] userShowID],
                                 d_memberTrueName:[UnifiedUserInfoManager share].userName
                                 };
    [arrayPeople addObject:dictPerson];
    self.params[d_members] = arrayPeople;
    
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/Task/ProjectAdd";}
- (NSString *)type { return @"PUT";}

- (BaseResponse *)prepareResponse:(id)data {
    ProjectCreateResponse *response = [ProjectCreateResponse new];
    
    response.showId = [data valueStringForKey:@"showId"];
    
    return response;
}

@end
