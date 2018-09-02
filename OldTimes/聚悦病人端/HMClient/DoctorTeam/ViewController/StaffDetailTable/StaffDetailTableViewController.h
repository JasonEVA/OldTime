//
//  StaffDetailTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffDetailTableViewController : UITableViewController
{
    StaffInfo* staff;
}

- (id) initWithStaffInfo:(StaffInfo*) staffinfo;
@end
