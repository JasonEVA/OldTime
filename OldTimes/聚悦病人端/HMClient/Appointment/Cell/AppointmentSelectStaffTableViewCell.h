//
//  AppointmentSelectStaffTableViewCell.h
//  HMClient
//
//  Created by lkl on 16/11/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointStaffModel.h"

@interface AppointmentSelectStaffTableViewCell : UITableViewCell

- (void) setStaffInfo:(AppointStaffModel*) staff;
- (void) setIsSelected:(BOOL) selected;
@end
