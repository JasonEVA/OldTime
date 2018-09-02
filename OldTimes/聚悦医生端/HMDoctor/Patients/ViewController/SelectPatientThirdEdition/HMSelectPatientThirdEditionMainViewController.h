//
//  HMSelectPatientThirdEditionMainViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//  2.3版选人主界面

#import "HMBaseViewController.h"
@class NewPatientListInfoModel;

typedef void(^PatientSelectedBlock)(NSArray<NewPatientListInfoModel *> *selectedPatients);

@interface HMSelectPatientThirdEditionMainViewController : HMBaseViewController
@property (nonatomic, strong)  NSMutableArray *allSelectedPatients;
@property (nonatomic) NSInteger maxSelectedNum;               //至多选择人数(默认为50，可以不传这个参数。如需自定义人数设置即可)

@property (nonatomic) BOOL canSelectAll;  // 是否能全选

//确定选择回调block方法
- (void)getSelectedPatient:(PatientSelectedBlock)block;
//根据走下角按钮titel和已选人初始化
- (instancetype)initWithSendTitel:(NSString *)titel selectedMember:(NSMutableArray< NewPatientListInfoModel *> *)selectedMember;
@end
