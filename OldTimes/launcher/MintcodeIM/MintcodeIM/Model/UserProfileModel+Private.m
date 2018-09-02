//
//  UserProfileModel+Private.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "UserProfileModel+Private.h"
#import "NSDictionary+IMSafeManager.h"
#import <MJExtension/MJExtension.h>

#define Dict_sqlID             @"sqlID"
#define Dict_modified          @"modified"    // 用户最后更新时间	long	选填	如果用户存在则返回
#define Dict_nickName          @"nickName"    // 昵称	string	选填	如果用户存在则返回
#define Dict_avatar            @"avatar"      // 头像	string	选填	如果用户存在则返回
#define Dict_type              @"type"        // 用户类型	string	选填	如 con 如果用户存在则返回
#define Dict_userName          @"userName"    // 用户名	string	选填	如果用户存在则返回
#define Dict_memberList        @"memberList"  // 如果是群返回成员列表
#define Dict_memberJasonString @"memberList"  // 群成员Json字符串格式
#define Dict_receiveMode       @"receiveMode"
#define Dict_extension         @"extension"
@implementation UserProfileModel (Private)

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict != nil)
        {
            self.modified = [[dict im_valueNumberForKey:Dict_modified] longLongValue];
            self.nickName = [dict im_valueStringForKey:Dict_nickName];
            self.avatar   = [dict im_valueStringForKey:Dict_avatar];
            self.type     = [dict im_valueStringForKey:Dict_type];
            self.userName = [dict im_valueStringForKey:Dict_userName];
            self.extension = [dict im_valueStringForKey:Dict_extension];
            NSArray *memeberListDictionary = [dict im_valueArrayForKey:Dict_memberList];
            self.memberJasonString = [memeberListDictionary mj_JSONString];
            
            self.receiveMode = [[dict im_valueNumberForKey:Dict_receiveMode] integerValue];
            self.tag = [dict im_valueStringForKey:@"tag"];
        }
    }
    return self;
}

@end
