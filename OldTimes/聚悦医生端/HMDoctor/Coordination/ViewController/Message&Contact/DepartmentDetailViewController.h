//
//  DepartmentDetailViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBaseViewController.h"

@class CoordinationDepartmentModel;

@interface DepartmentDetailViewController : HMBaseViewController

@property (nonatomic, strong)  CoordinationDepartmentModel  *deptModel; // <##>
@end
