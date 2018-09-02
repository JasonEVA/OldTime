//
//  DepartmentSelectViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrgTeamSelectViewController.h"

@protocol DepartmentSelectDelegate <NSObject>

- (void) departmentSelected:(DepartmentInfo*) department;

@end


@interface DepartmentSelectViewController : OrgTeamSelectViewController
{
    
}

+ (void) showInParentController:(UIViewController*) parentController
                       Delegate:(id<DepartmentSelectDelegate>) delegate
                          OrgId:(NSInteger) orgId;
@end
