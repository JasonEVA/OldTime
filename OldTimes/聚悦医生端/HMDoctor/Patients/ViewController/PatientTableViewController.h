//
//  PatientTableViewController.h
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientInfo.h"

typedef enum : NSUInteger {
    PatientTableIntent_None,
    PatientTableIntent_Survey,
    
} PatientTableIntent;

@interface PatientTableViewController : UITableViewController
{
//     NSArray* patientGroups;
}
@property (nonatomic, strong) NSArray *patientGroups;     //病人群组信息
@property (nonatomic, assign) PatientTableIntent intent;
@property (nonatomic, strong) NSMutableArray *groupArr;     //病人群组信息
- (PatientInfo*) patientInfoWithIndex:(NSIndexPath *)indexPath;
- (void) patientGroupLoaded:(NSArray*) groups;
@end
