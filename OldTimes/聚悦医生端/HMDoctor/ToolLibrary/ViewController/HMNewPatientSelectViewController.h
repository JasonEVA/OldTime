//
//  HMNewPatientSelectViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/10/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//  新版病人选择界面

#import "PatientTableViewController.h"

@protocol HMNewPatientSelectViewControllerDelegate <NSObject>

- (void)HMNewPatientSelectViewControllerDelegateCallBack_selectedPatientChanged;

@end
@interface HMNewPatientSelectViewController : PatientTableViewController
@property (nonatomic, weak) id<HMNewPatientSelectViewControllerDelegate> selectDelegate;

@property (nonatomic, strong) NSMutableArray* selectedPatients;
@end
