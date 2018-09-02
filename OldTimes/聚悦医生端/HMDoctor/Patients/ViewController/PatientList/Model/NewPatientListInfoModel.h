//
//  NewPatientListInfoModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PatientInfo;

@interface NewPatientListInfoModel : NSObject

@property (nonatomic, assign)  NSInteger  age; //
@property (nonatomic, assign)  NSInteger  alertCount; // 预警次数
@property (nonatomic, assign)  NSInteger  attentionStatus; // 关注状态 1：关注 2：未关注
@property (nonatomic, copy)  NSString  *avatar; //
@property (nonatomic, copy)  NSString  *diseaseTitle; // 疾病名称
@property (nonatomic, copy)  NSString  *diseaseId; //
@property (nonatomic, copy)  NSString  *illDiagnose; // 诊断
@property (nonatomic, copy)  NSString  *joinDate; // 入组时间
@property (nonatomic, assign)  double  orderMoney; // 费用
@property (nonatomic, assign)  NSInteger  paymentType; // 收费类型 1：免费 2：收费
@property (nonatomic, copy)  NSString  *productName; // 服务名称
@property (nonatomic, copy)  NSString  *productId; //
@property (nonatomic, copy)  NSString  *sex; //
@property (nonatomic, copy)  NSString  *staffNames; //
@property (nonatomic, copy)  NSString  *teamName; // 团队名称
@property (nonatomic, copy)  NSString  *teamId; //
@property (nonatomic, assign)  NSInteger  userId; //
@property (nonatomic, copy)  NSString  *userName; //
@property (nonatomic, copy)  NSDictionary  *userTestDatas; // <##>
@property (nonatomic, copy)  NSString  *imGroupId; // IM群ID
@property (nonatomic) NSInteger blocId; //集团Id
@property (nonatomic, assign)  NSInteger  blocRank; //集团用户等级(默认 0) 0 无等级 1 普通 , 2 中层 , 3 VIP
@property (nonatomic, assign)  NSInteger  classify; //
@property (nonatomic, copy)  NSString  *rootTypeCode; //
@property (nonatomic, copy)  NSString  *idCard; //
@property (nonatomic, copy)  NSString  *blocName; // 集团名

- (PatientInfo *)convertToPatientInfo;
@end
