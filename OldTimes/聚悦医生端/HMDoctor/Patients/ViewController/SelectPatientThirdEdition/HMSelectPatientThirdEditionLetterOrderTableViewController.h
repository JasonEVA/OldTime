//
//  HMSelectPatientThirdEditionLetterOrderTableViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//   第三版选患者按字母排序VC

#import <UIKit/UIKit.h>
@class NewPatientListInfoModel;

@protocol HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegate <NSObject>

- (void)HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegateCallBack_letterSelectedPatientChanged;

@end

@interface HMSelectPatientThirdEditionLetterOrderTableViewController : UITableViewController
- (void)configPatientsData:(NSArray<NewPatientListInfoModel *> *)patients;
@property (nonatomic, strong) NSMutableArray* letterSelectedPatients;
@property (nonatomic) NSInteger maxSelectedNum;        //至多选择人数
@property (nonatomic, weak) id<HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegate> delegate;
//刷新数据源
- (void)reloadLetterVCWithArray:(NSMutableArray *)array;
//隐藏搜索界面
- (void)hideSearchVC;
@end
