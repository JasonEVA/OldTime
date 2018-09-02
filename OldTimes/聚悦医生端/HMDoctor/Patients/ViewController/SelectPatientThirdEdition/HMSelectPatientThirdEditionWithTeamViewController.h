//
//  HMSelectPatientThirdEditionWithTeamViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//  2.3版团队排序选人
#import "HMNewPatientSelectViewController.h"
@class PatientSearchResultTableViewController;
@protocol HMSelectPatientThirdEditionWithTeamViewControllerDelegate <NSObject>

- (void)HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged;

@end
@interface HMSelectPatientThirdEditionWithTeamViewController : UITableViewController
@property (nonatomic, weak) id<HMSelectPatientThirdEditionWithTeamViewControllerDelegate> selectDelegate;
@property (nonatomic, strong) NSMutableArray* selectedPatients;
@property (nonatomic, strong) NSMutableArray *patientGroups;     //病人群组信息
@property (nonatomic) NSInteger maxSelectedNum;                  //至多选择人数
//设置数据源
- (void)fillDataWithArray:(NSArray *)groups;
//刷新已选人数据源
- (void)reloadTeamVCWithArray:(NSMutableArray *)array;
//隐藏搜索界面
- (void)hideSearchVC;
@end
