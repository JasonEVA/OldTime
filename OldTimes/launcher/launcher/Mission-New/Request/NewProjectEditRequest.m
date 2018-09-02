//
//  NewProjectEditRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewProjectEditRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import <MintcodeIM/MintcodeIM.h>

static const NSString *d_memberName     = @"memberName";
static const NSString *d_memberTrueName = @"memberTrueName";


@implementation NewProjectEditRequest

- (NSString *)api { return @"/Task-Module/TaskV2/ProjectEdit";}
- (NSString *)type { return @"POST";}

- (void)requestData
{
    [self.params setValue:_showId forKey:@"showId"];
    [self.params setValue:_name   forKey:@"name"];
    
    // add
    NSMutableArray *arrayPeople = [NSMutableArray array];
    for (UserProfileModel *midel in _addArray) {
        NSDictionary *dictPerson = @{
                                     d_memberName:midel.userName,
                                     d_memberTrueName:midel.nickName
                                     };
        [arrayPeople addObject:dictPerson];
    }
    // dele
    NSMutableArray * dele = [NSMutableArray array];
    for (NSString * model in _deleArray) {
        [dele addObject:model];
    }
    if (arrayPeople.count) {
        [self.params setValue:arrayPeople   forKey:@"addMembers"];
    }
    if (dele.count) {
        [self.params setValue:dele          forKey:@"deleteMembers"];
    }
    [super requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    NewProjectEditResponse *response = [NewProjectEditResponse new];
    return response;
}

@end

@implementation NewProjectEditResponse



@end



