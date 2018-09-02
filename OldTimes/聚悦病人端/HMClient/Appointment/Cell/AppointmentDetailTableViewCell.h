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
    UILabel* lbApplyTimeTitle;
    UILabel* lbStaffNameTitle;
    UILabel* lbNoteTitle;
    
    UILabel* lbSymptomTitle;
    
    UILabel* lbApplyTime;
    UILabel* lbStaffName;
    UILabel* lbNote;
    UILabel* lbSymptom;
}
@property (nonatomic, readonly) UIButton* cancelButton;

- (void) createSubviews;
- (void) subviewLayout;

- (void) setAppointmentDetail:(AppointmentDetail*) detail;
@end


@interface AppointmentFinishedDetailTableViewCell : AppointmentDetailTableViewCell
{
    

    
}
@end
