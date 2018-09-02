//
//  CreateGroupViewController.h
//  launcher
//
//  Created by Lars Chen on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  创建群聊页面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserProfileModel.h"

@protocol CreateGroupViewControllerDelegate <NSObject>

@optional
// 创建完毕群组的委托回调
- (void)CreateGroupViewControllerDelegateCallBack_finishCreateGroupWithData:(UserProfileModel *)model;

@end

@interface CreateGroupViewController : BaseViewController

@property (nonatomic,weak) id <CreateGroupViewControllerDelegate> delegate;

// 以下是增加群成员需要
@property (nonatomic, copy)  NSString  *groupID; // 群ID
@property (nonatomic)  BOOL  isAddPeople; // 是否是加人界面
@property (nonatomic, copy)  NSArray  *arrayExist; // 已存在的人
@end
