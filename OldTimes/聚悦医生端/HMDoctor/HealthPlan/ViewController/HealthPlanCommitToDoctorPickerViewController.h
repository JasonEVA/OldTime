//
//  HealthPlanCommitToDoctorPickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/9/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffTeamDoctorModel.h"

typedef void(^HealthPlanSubmitDoctorPickHandle)(StaffTeamDoctorModel* staffModel);

@interface HealthPlanCommitToDoctorPickerViewController : UIViewController

+ (void) showWithUserId:(NSString*) userId
                 handle:(HealthPlanSubmitDoctorPickHandle) handle;
@end
