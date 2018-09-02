//
//  PatientListKeyOrderAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//  患者列表关键字排序

#import "ATTableViewAdapter.h"

@class NewPatientListInfoModel;

@protocol PatientListKeyOrderAdapterDelegate <NSObject>
    
- (void)patientListKeyOrderAdapterDelegateCallBack_followStatus:(BOOL)follow;

- (void)patientListKeyOrderAdapterDelegateCallBack_scrollViewDidScroll:(CGFloat)offsetY;

@end

@interface PatientListKeyOrderAdapter : ATTableViewAdapter

@property (nonatomic, weak)  id<PatientListKeyOrderAdapterDelegate>  customDelegate; // <##>
@property (nonatomic, assign)  BOOL  filterFollow; // <##>

- (void)reloadTableViewWithOriginData:(NSArray<NewPatientListInfoModel *> *)originData;
@end
