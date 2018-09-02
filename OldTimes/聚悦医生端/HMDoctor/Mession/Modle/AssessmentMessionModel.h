//
//  AssessmentMessionModel.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssessmentMessionModel : NSObject

//用户基本信息
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSString* userIll;    //用户疾病

//
@property (nonatomic, retain) NSString* assessmentReportId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString* statusName;

@property (nonatomic, retain) NSString* templateId;
@property (nonatomic, retain) NSString* templateTypeCode;
@property (nonatomic, retain) NSString* templateTypeId;
@property (nonatomic, retain) NSString* templateTypeName;   //评估类型
@property (nonatomic, retain) NSString* surveyMoudleName;   //评估项目

@property (nonatomic, assign) NSInteger staffUserId;       //指定给医生的userId
@property (nonatomic, retain) NSString* planDate;          //评估计划发送时间
@end


@interface AssessmentRecordModel :NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger staffUserId;       //指定给医生的userId
@property (nonatomic, retain) NSString* templateId;        //模版Id
@property (nonatomic, retain) NSString* assessmentReportId;
@end


//以下是评估模版分类模型
@interface AssessmentCategoryModel : NSObject

@property (nonatomic, assign) NSInteger deptCode;
@property (nonatomic, assign) NSInteger deptId;
@property (nonatomic, copy) NSString *deptName;
@property (nonatomic, strong) NSArray *details;

@end

@interface AssessmentCategoryDetailsModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) NSInteger categoryType;
@property (nonatomic, assign) NSInteger deptId;
@property (nonatomic, assign) NSInteger orderNum;

//患者userId;
@property (nonatomic, strong) NSString *patientUserId;

@end


@interface AssessmentTemplateModel : NSObject

@property (nonatomic, assign) NSInteger assessmentType;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, assign) NSInteger templateId;
@property (nonatomic, copy) NSString *templateName;

//患者userId;
@property (nonatomic, strong) NSString *patientUserId;

@end

