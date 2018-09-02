//
//  PrescribeChoosePharmacyTemplateViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//  选择用药模板

#import "HMBaseViewController.h"

typedef void (^cellClick)(NSString *modelID);
@interface PrescribeChoosePharmacyTemplateViewController : HMBaseViewController
- (void)cellClick:(cellClick)block;
@end
