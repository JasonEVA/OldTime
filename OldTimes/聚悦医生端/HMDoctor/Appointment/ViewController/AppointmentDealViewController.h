//
//  AppointmentDealViewController.h
//  HMDoctor
//
//  Created by lkl on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "AppointmentInfo.h"

@interface ApplayInfoView : UIView

- (void)setApplayInfo:(AppointmentInfo *)appointInfo;

@end

@interface AppointmentDealViewController : HMBasePageViewController
{
    ApplayInfoView *applyInfoView;
    UIButton *confirmBtn;
    AppointmentInfo* appointInfo;
}
@end
