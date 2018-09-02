//
//  FriendValidationViewController.h
//  launcher
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  好友验证

#import "BaseViewController.h"

@class  MessageRelationInfoModel;

typedef void(^FriendValidationViewControllerBlock)(NSString * remark);

@interface FriendValidationViewController : BaseViewController

@property(nonatomic, copy) NSNumber  *groupID;

/** 需要邀请好友后的备注名,请使用此方法初始化 **/
- (instancetype)initWithBlock:(FriendValidationViewControllerBlock)block;

- (void)setDataWithModel:(MessageRelationInfoModel *)model;

@end
