//
//  NewProjectAddRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewProjectAddRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "NSDictionary+SafeManager.h"

static const NSString *d_name    = @"name";
static const NSString *d_members = @"members";

static const NSString *d_memberName     = @"memberName";
static const NSString *d_memberTrueName = @"memberTrueName";

@implementation NewProjectAddRequest

- (void)createProject:(NSString *)projectName people:(NSArray *)people {
    self.params[d_name] = projectName;
    _projectName = projectName;
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
- (NSString *)api { return @"/Task-Module/TaskV2/ProjectAdd";}
- (NSString *)type { return @"PUT";}
- (BaseResponse *)prepareResponse:(id)data {
    NewProjectAddResponse * response = [NewProjectAddResponse new];
    response.showId = [data valueStringForKey:@"showId"];
    response.projectName = self.projectName;
    response.createUser = [data valueStringForKey:@"createUser"];
    return response;
}


@end

@implementation NewProjectAddResponse

@end