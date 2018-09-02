//
//  AppApprovalModel.h
//  launcher
//
//  Created by Andrew Shen on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  消息审批详情model

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "NewApplyAllFormModel.h"

@interface AppApprovalModel : NSObject

@property (nonatomic, strong)  NSString  *title; // String 审批标题
@property (nonatomic)  long long  start; // Long 审批开始时间
@property (nonatomic)  long long  end; // Long 审批结束时间
@property (nonatomic)  long long  deadline; // Long 审批期限
@property (nonatomic, strong)  NSString  *id; // String 审批的id
@property (nonatomic, strong)  NSString  *fee; // String 审批金额
@property (nonatomic)  NSInteger  isDeadlineAllday; // Int 审批期限是否全天，1代表是，0代表不是
@property (nonatomic)  NSInteger  isTimeslotAllday; // Int 时间段是否全天，1代表是，0代表不是
@property (nonatomic, strong)  NSString  *backup; // String 备注
@property (nonatomic, strong)  NSString  *approvalType; // String 审批类型
@property (nonatomic, strong) NSString *approvalStatus;
@property (nonatomic, strong) NSString * approvalShowID; // 请假 = vEyVJ7K29qcovp3p     费用 = BB1xoKW53kCPW7OP
@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *workflowId;
@property (nonatomic, strong) NSArray *triggers;

@property (nonatomic, strong) NewApplyAllFormModel *approvalForm;
@property (nonatomic, strong) NSDictionary *approvalFormData;

/// 筛选出聊天显示的字断，审批人、抄送人不需要
- (NSArray<NewApplyFormBaseModel *> *)sortedForChatUI;

@end
