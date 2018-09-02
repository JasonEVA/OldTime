//
//  CreateDocumetnMessionInfo.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateDocumetnMessionInfo : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, retain) NSString* serviceBeginTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString* statusName;

@property (nonatomic, retain) NSString* assessmentReportId;
@property (nonatomic, retain) NSString* healtyRecordId;

@property (nonatomic, assign) NSInteger staffUserId;       //指定给医生的userId
@end


@interface CreateDocumetnTemplateModel : NSObject

@property (nonatomic, retain) NSString* templateCode;
@property (nonatomic, retain) NSString* templateId;
@property (nonatomic, retain) NSString* templateName;

@end

typedef NS_ENUM(NSUInteger, CDATemplateTypeDataType) {
    TemplateType_CommonaAsessment = 1,      //一般性建档评估
    TemplateType_TreatmentRiskAssessment,   //治疗风险评估
    TemplateType_ConcurrentRiskAssessment,  //并发症风险评估
    TemplateType_Diagnosis,                 //诊断
};

@interface CreateDocumetnTemplateTypeModel : NSObject

@property (nonatomic, retain) NSString* recordId;
@property (nonatomic, assign) NSInteger assessmentType;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, readonly) NSInteger dataType;
@property (nonatomic, readonly) NSInteger userId;

@property (nonatomic, retain) NSString* templateId;
@property (nonatomic, retain) NSString* templateTypeCode;
@property (nonatomic, retain) NSString* templateTypeId;
@property (nonatomic, retain) NSString* templateTypeName;
@property (nonatomic, retain) NSString* surveyMoudleName;

@property (nonatomic, readonly) NSString* reportComments;

@end