//
//  DoctorContactDetailInfoViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医生联系人详情界面

#import "HMBaseViewController.h"
#import "HMDoctorEnum.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface DoctorContactDetailInfoViewController : HMBaseViewController

- (instancetype)initWithRelationType:(ContactRelationshipType)type infoModel:(id)model;
@end
