//
//  UserProfileModel.m
//  MintcodeIMFramework
//
//  Created by Andrew Shen on 15/6/11.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "UserProfileModel.h"
#import <MJExtension/MJExtension.h>

@implementation UserProfileModel

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

+ (NSDictionary *)objectClassInArray {
    return @{@"memberList" : [UserProfileModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"memberJasonString" : @"memberList"};
}

// 群Model通过昵称获得他自己的uid
- (NSString *)getGroupMemberUserNameWithNickName:(NSString *)nickName
{
    for (UserProfileModel *model in self.memberList)
    {
        if ([nickName isEqualToString:model.nickName])
        {
            return model.userName;
        }
    }

    return @"";
}

- (void)updateMemberJsonString {
    self.memberJasonString = [[UserProfileModel mj_keyValuesArrayWithObjectArray:self.memberList] mj_JSONString];
}

@end
