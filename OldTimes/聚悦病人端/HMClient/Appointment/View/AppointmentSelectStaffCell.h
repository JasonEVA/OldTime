//
//  AppointmentSelectStaffCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointStaffModel.h"

@interface AppointmentSelectStaffCell : UIControl
{
    
}

- (void) setStaffInfo:(AppointStaffModel*) staff;
- (void) setIsTeamLeader:(BOOL) isLeader;
- (void) setIsSelected:(BOOL) selected;
@end
