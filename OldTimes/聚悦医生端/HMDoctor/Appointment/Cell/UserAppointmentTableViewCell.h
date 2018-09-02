//
//  UserAppointmentTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentInfo.h"



@interface UserAppointmentTableViewCell : UITableViewCell
{
    UIView* appointmentview;
    UIView* statusview;
    
    UILabel* lbStatus;
    
    UILabel* lbPatientName;
    UILabel* lbPatientInfo;
}
@property (nonatomic,strong) UIButton *archiveButton;
@property (nonatomic, readonly) UIButton* dealbutton;

- (void) setAppointmentInfo:(AppointmentInfo*) appoint;
@end

/*
 UserDealedAppointmentTableViewCell 
 顾问已经处理过的用户约诊TableViewCell
 */
@interface UserDealedAppointmentTableViewCell : UserAppointmentTableViewCell

@end

/*
 UserUnDealedAppointmentTableViewCell
 等待顾问处理过的用户约诊TableViewCell
 */
@interface UserUnDealedAppointmentTableViewCell : UserAppointmentTableViewCell

@end
