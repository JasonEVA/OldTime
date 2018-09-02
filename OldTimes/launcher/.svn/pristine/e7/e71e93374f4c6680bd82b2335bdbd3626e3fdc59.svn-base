//
//  ProjectDetailModel.m
//  launcher
//
//  Created by TabLiu on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ProjectDetailModel.h"
#import "NSDictionary+SafeManager.h"
#import <MintcodeIM/MintcodeIM.h>


@implementation ProjectDetailModel
- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _createUser = [dic valueStringForKey:@"createUser"];
        _name = [dic valueStringForKey:@"name"];
        _showId = [dic valueStringForKey:@"showId"];
        
        _members = [NSMutableArray array];
        _UID_Array = [NSMutableArray array];
        NSArray * array = [dic objectForKey:@"members"];
        for (NSDictionary * dict in array) {
            UserProfileModel * model = [[UserProfileModel alloc] init];
            model.nickName = [dict valueStringForKey:@"memberTrueName"];
            model.userName = [dict valueStringForKey:@"memberName"];

            [_members addObject:model];
            [_UID_Array addObject:model.userName];
        }
        
    }
    return self;
}

@end

