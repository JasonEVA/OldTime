//
//  PatientSelectTableViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientTableViewController.h"
#import "PatientListTableViewCell.h"


@protocol PatientSelectTableViewDelegate <NSObject>

- (void) selectedPatientChanged;

@end

@interface PatientSelectTableViewController : PatientTableViewController
{
    
}

@property (nonatomic, weak) id<PatientSelectTableViewDelegate> selectDelegate;

@property (nonatomic, copy) NSMutableArray* selectedPatients;
@end
