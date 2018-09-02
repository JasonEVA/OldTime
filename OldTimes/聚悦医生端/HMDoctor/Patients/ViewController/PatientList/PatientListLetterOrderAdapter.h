//
//  PatientListLetterOrderAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//  字母排序adapter

#import "ATTableViewAdapter.h"

@class NewPatientListInfoModel;

@protocol PatientListLetterOrderAdapterDelegate <NSObject>

- (void)patientListLetterOrderAdapterDelegateCallBack_followStatus:(BOOL)follow;

- (void)patientListLetterOrderAdapterDelegateCallBack_scrollViewDidScroll:(CGFloat)offsetY;
@end

@interface PatientListLetterOrderAdapter : ATTableViewAdapter

@property (nonatomic, weak)  id<PatientListLetterOrderAdapterDelegate>  customDelegate; // <##>
@property (nonatomic, assign)  BOOL  filterFollow; // <##>

- (void)reloadTableViewWithOriginData:(NSArray<NewPatientListInfoModel *> *)originData completion:(void (^)())completion;
@end
