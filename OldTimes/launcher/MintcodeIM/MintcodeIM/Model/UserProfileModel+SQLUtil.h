//
//  UserProfileModel+SQLUtil.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <MintcodeIM/MintcodeIM.h>

#define UserProfile_sqlID             @"sqlID"
#define UserProfile_modified          @"modified"    // 用户最后更新时间	long	选填	如果用户存在则返回
#define UserProfile_nickName          @"nickName"    // 昵称	string	选填	如果用户存在则返回
#define UserProfile_avatar            @"avatar"      // 头像	string	选填	如果用户存在则返回
#define UserProfile_type              @"type"        // 用户类型	string	选填	如 con 如果用户存在则返回
#define UserProfile_userName          @"userName"    // 用户名	string	选填	如果用户存在则返回
#define UserProfile_memberList        @"memberList"  // 如果是群返回成员列表
#define UserProfile_memberJasonString @"memberList"  // 群成员Json字符串格式
#define UserProfile_receiveMode       @"receiveMode"
#define UserProfile_tag               @"tag"
#define UserProfile_extension         @"extension"

@interface UserProfileModel (SQLUtil)

@end
