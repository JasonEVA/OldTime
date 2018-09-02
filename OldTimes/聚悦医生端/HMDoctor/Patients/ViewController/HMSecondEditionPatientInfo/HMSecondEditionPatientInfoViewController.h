//
//  HMSecondEditionPatientInfoViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版患者基本信息页

#import "HMBaseViewController.h"

@interface HMSecondEditionPatientInfoViewController : HMBaseViewController
@property (nonatomic, readonly)  BOOL  needRequestUserInfo; // <##>

- (instancetype)initWithUserID:(NSString *)userID;

- (void)reloadPatientInfoWithUserID:(NSString *)userID;
@end
