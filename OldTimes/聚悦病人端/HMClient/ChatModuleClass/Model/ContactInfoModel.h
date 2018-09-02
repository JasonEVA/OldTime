//
//  ContactInfoModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//  联系人信息model

#import <Foundation/Foundation.h>
#import <MintcodeIMKit/MintcodeIMKit.h>
@interface ContactInfoModel : NSObject
@property (nonatomic, copy)  NSString  *avatarPath; // <##>
@property (nonatomic, copy)  NSString  *name; // <##>
@property (nonatomic, copy)  NSString  *position; // <##>
@property (nonatomic)  BOOL  selected; // 是否选择
@property (nonatomic)  BOOL  nonSelectable; // 是否禁止选择选择
@property (nonatomic,getter=isGroup)  BOOL  group; // 是否是群/讨论组
@property (nonatomic, strong) MessageRelationInfoModel *relationInfoModel;  //IM SDK 中的好友model

- (instancetype)initWithUserContactInfoModel:(ContactInfoModel *)model;

- (instancetype)initWithUserProfileModel:(UserProfileModel *)model;

- (instancetype)initWithContactDetailModel:(ContactDetailModel *)model;

- (instancetype)initWithMessageRelationInfoModel:(MessageRelationInfoModel *)model;

- (instancetype)initWithSuperGroupListModel:(SuperGroupListModel *)model;

- (ContactDetailModel *)convertToContactDetailModel;
@end
