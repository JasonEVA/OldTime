//
//  PrescribePatientsTableViewController.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientInfo.h"

typedef enum : NSUInteger {
    PatientTableIntent_None,
    PatientTableIntent_Survey,
    
} PatientTableIntent;

@interface PrescribePatientsTableViewController : UITableViewController


@property (nonatomic, assign) PatientTableIntent intent;

- (PatientInfo*) patientInfoWithIndex:(NSIndexPath *)indexPath;
@end
