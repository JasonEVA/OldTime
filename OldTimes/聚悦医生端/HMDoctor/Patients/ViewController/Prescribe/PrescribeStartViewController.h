//
//  PrescribeStartViewController.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "PatientInfo.h"

@interface PrescribeStartViewController : HMBasePageViewController

@end

@interface PrescribeStartTableViewController : UITableViewController

@property (nonatomic, strong) PatientInfo *patientinfo;
@end
