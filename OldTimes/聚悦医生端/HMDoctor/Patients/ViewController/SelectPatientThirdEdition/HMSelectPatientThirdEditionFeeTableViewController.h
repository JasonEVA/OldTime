//
//  HMSelectPatientThirdEditionFeeTableViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第三版选人是否付费界面

#import <UIKit/UIKit.h>
@class PatientInfo;
@protocol HMSelectPatientThirdEditionFeeTableViewControllerDelegate <NSObject>

- (void)HMSelectPatientThirdEditionFeeTableViewControllerDelegateCallBack_feeSelectedPatientChanged;

@end

@interface HMSelectPatientThirdEditionFeeTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *feeSelectedPatients;
@property (nonatomic, strong) NSMutableArray *feeAllPatients;
@property (nonatomic, weak) id<HMSelectPatientThirdEditionFeeTableViewControllerDelegate> delegate;

- (void)configPatientsData:(NSArray<PatientInfo *> *)patients;
//隐藏搜索界面
- (void)hideSearchVC;
//刷新数据源
- (void)reloadLetterVCWithArray:(NSMutableArray *)array;
@end
