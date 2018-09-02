//
//  PatientLetterOrderTableViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/10/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//  字母排序病人界面

#import <UIKit/UIKit.h>

@class PatientInfo;

@interface PatientLetterOrderTableViewController : UITableViewController

- (void)configPatientsData:(NSArray<PatientInfo *> *)patients;
@end
