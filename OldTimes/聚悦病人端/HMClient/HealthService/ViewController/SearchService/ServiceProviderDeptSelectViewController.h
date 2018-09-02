//
//  ServiceProviderDeptSelectViewController.h
//  HMClient
//
//  Created by yinquan on 16/12/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrgTeamSelectViewController.h"
#import "HosipitalInfo.h"

@protocol ServiceProviderDeptSelectDelegate <NSObject>

- (void) departmentSelected:(DepartmentInfo*) hosipital;

@end

@interface ServiceProviderDeptSelectViewController : OrgTeamSelectViewController

+ (void) showInParentController:(UIViewController*) parentController
                       Delegate:(id<ServiceProviderDeptSelectDelegate>) delegate
                          OrgId:(NSInteger) orgId
                  productTypeId:(NSInteger) productTypeId;

@end
