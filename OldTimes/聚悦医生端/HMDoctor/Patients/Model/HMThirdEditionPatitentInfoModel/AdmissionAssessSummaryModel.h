//
//  AdmissionAssessSummaryModel.h
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BfzResultListModel : NSObject

@property (nonatomic, copy) NSString *depName;
@property (nonatomic, copy) NSString *fillTime;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *staffName;
@property (nonatomic, copy) NSString *surveyMoudleName;
@property (nonatomic, copy) NSString *surveyType;
@property (nonatomic, copy) NSString *surveyTypeStr;
@property (nonatomic, strong) NSArray *evaluateResult;
@end

@interface AdmissionAssessSummaryModel : NSObject

@property (nonatomic, strong) NSArray *bfzResultList;     //评估
@property (nonatomic, strong) NSArray *jbResultList;      //诊断
@end
