//
//  DoctorAvatarInfoView.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医生头像信息view

#import <UIKit/UIKit.h>

@interface DoctorAvatarInfoView : UIView

- (void)configImageName:(NSString *)imageName name:(NSString *)name teamLeader:(BOOL)teamLeader;

@end
