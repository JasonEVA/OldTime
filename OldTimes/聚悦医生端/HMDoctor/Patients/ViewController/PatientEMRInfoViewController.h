//
//  PatientEMRInfoViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//  用户电子病历界面

#import "HMBaseViewController.h"

@interface PatientEMRInfoViewController : HMBaseViewController
@property (nonatomic, readonly)  BOOL  needRequestEMRInfo; // <##>

- (instancetype)initWithUserID:(NSString *)userID;

- (void)reloadEMRInfoWithUserID:(NSString *)userID;
@end
