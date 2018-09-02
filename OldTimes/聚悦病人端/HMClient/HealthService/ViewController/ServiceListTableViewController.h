//
//  ServiceListTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCategory.h"



@interface ServiceListStartViewController : HMBasePageViewController

@end

@interface ServiceListTableViewController : UITableViewController
{
    
}

- (void) setSelectedOrgId:(NSInteger) orgId;
- (void) setSelectedDeptId:(NSInteger) deptId;

@property (nonatomic, retain) ServiceCategory* cate;
@end
