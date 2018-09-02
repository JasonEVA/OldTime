//
//  HMThirdEditionPatientViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第三版患者基本信息页

#import "HMBaseViewController.h"

@interface HMThirdEditionPatientViewController : HMBaseViewController
@property (nonatomic, readonly)  BOOL  needRequestUserInfo; // <##>

- (instancetype)initWithUserID:(NSString *)userID;

- (void)reloadPatientInfoWithUserID:(NSString *)userID;
@end
