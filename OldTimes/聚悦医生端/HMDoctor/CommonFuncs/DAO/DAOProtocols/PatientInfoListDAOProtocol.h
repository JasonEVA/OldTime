//
//  PatientInfoListDAOProtocol.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewPatientListInfoModel.h"

typedef void(^PatientListCompletionHandler)(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results);
typedef void(^PatientListFollowCompletionHandler)(BOOL requestSuccess, NSString *errorMsg);

@protocol PatientInfoListDAOProtocol <NSObject>

// 所有数据源
- (void)requestPatientListImmediately:(BOOL)immediately CompletionHandler:(PatientListCompletionHandler)completion;

// 根据某一字段去重
- (void)requestPatientListImmediately:(BOOL)immediately removeDuplicateWithId:(NSString *)removeDuplicateId CompletionHandler:(PatientListCompletionHandler)completion;

- (void)requestPatientList;

// 更新关注状态
- (void)updatePatientFollowStatus:(BOOL)follow patientID:(NSInteger)patientID completion:(PatientListFollowCompletionHandler)completion;

- (void)queryPatientInfoWithPatientID:(NSInteger)patientID completion:(void(^)(NewPatientListInfoModel *model))completion;
@end
