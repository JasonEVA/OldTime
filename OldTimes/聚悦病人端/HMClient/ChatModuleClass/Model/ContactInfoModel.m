//
//  ContactInfoModel.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactInfoModel.h"

@implementation ContactInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"谢天笑";
        self.position = @"糖尿病专家";
        self.selected = NO;
        self.relationInfoModel = [MessageRelationInfoModel new];
    }
    return self;
}

- (instancetype)initWithUserContactInfoModel:(ContactInfoModel *)model {
    return model;
}

- (instancetype)initWithUserProfileModel:(UserProfileModel *)model {
    self = [super init];
    if (self) {
        self.relationInfoModel.relationName = model.userName;
        self.relationInfoModel.nickName = model.nickName;
        self.relationInfoModel.relationAvatar = model.avatar;
    }
    return self;
}

- (instancetype)initWithContactDetailModel:(ContactDetailModel *)model {
    self = [super init];
    if (self) {
        self.relationInfoModel.relationName = model._target;
        self.relationInfoModel.nickName = model._nickName;
        self.relationInfoModel.relationAvatar = model._headPic;
    }
    return self;

}

- (instancetype)initWithMessageRelationInfoModel:(MessageRelationInfoModel *)model {
    self = [super init];
    if (self) {
        self.relationInfoModel = model;
    }
    return self;
}

- (instancetype)initWithSuperGroupListModel:(SuperGroupListModel *)model {
    self = [super init];
    if (self) {
        self.relationInfoModel.relationName = model.userName;
        self.relationInfoModel.nickName = model.nickName;
        self.relationInfoModel.relationAvatar = model.avatar;
    }
    return self;
}


- (ContactDetailModel *)convertToContactDetailModel {
    ContactDetailModel *model = [ContactDetailModel new];
    model._target = self.relationInfoModel.relationName;
    model._nickName = self.relationInfoModel.nickName;
    model._headPic = self.relationInfoModel.relationAvatar;
    return model;
}



- (MessageRelationInfoModel *)relationInfoModel
{
    if (!_relationInfoModel) {
        _relationInfoModel = [MessageRelationInfoModel new];
    }
    return _relationInfoModel;
}

- (BOOL)isGroup {
    return [self.relationInfoModel.relationName hasSuffix:@"@ChatRoom"] || [self.relationInfoModel.relationName hasSuffix:@"@SuperGroup"];
}

@end
