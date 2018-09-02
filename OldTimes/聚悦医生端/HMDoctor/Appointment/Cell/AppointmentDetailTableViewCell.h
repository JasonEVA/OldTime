//
//  AppointmentDetailTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentInfo.h"

@interface AppointmentApplyStatusTableViewCell : UITableViewCell
{
    
}
- (void) setAppointmentDetail:(AppointmentDetail*) detail;

@end

@interface AppointmentDetailTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, readonly) UIButton* cancelButton;

- (void) setAppointmentDetail:(AppointmentDetail*) detail;
@end
