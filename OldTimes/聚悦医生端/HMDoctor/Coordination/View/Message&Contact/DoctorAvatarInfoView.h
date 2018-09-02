//
//  DoctorAvatarInfoView.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医生头像信息view

#import <UIKit/UIKit.h>

@class UserProfileModel;
@interface DoctorAvatarInfoView : UIView

- (void)configMemberInfo:(UserProfileModel *)model;

- (void)configImage:(UIImage *)image name:(NSString *)name position:(NSString *)position;

@end
