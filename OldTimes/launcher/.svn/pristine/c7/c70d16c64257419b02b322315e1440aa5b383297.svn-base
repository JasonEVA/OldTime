//
//  NewApplyCreateV2Request.h
//  launcher
//
//  Created by williamzhang on 16/4/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  新建审批

#import "BaseRequest.h"

@class NewApplyAllFormModel;

@interface NewApplyCreateV2Request : BaseRequest

- (void)approveNewWithApproveShowId:(NSString *)approveShowId
                         workflowId:(NSString *)workflowId
                             formId:(NSString *)formId
                              model:(NewApplyAllFormModel *)model;


- (void)approveNewWithApproveShowId:(NSString *)approveShowId
                         workflowId:(NSString *)workflowId
                             formId:(NSString *)formId
                              model:(NewApplyAllFormModel *)model
                           isUrgent:(NSInteger)isUrgent;

/**
 *  新建有审批期限的审批时优先配置审批时间
 *  @param deadlineTime 审批期限时间戳
 *  @param isWholeDay   是否全天
 */
- (void)configureApproveDeadlineTime:(long long)deadlineTime isWholeDay:(BOOL)isWholeDay;

@end
