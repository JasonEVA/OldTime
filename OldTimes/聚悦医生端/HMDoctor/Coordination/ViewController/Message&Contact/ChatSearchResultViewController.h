//
//  ChatSearchResultViewController.h
//  launcher
//
//  Created by Jason Wang on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//
//  搜索结果详情

#import <UIKit/UIKit.h>
#import "HMBaseViewController.h"

@interface ChatSearchResultViewController : HMBaseViewController

/** 字符串形式的uid，用户查找数据 */
@property (nonatomic, copy) NSString *strUid;
/*  msgid  */
@property (nonatomic,assign) long long msgid;
/** 联系人姓名 */
@property (nonatomic, copy) NSString *strName;
/** 联系人路径 */
@property (nonatomic, copy) NSString *avatarPath;
/** 联系人职位 */
@property (nonatomic, copy) NSString *strDepartment;
//消息对应在数据库中的id
@property (nonatomic) long long sqlId;
/* 是否是群聊 -- 用来判断是否展示群组成员昵称 */
@property (nonatomic) BOOL  IsGroup;

@end
