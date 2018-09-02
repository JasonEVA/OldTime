//
//  UserAlertInfo.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PatientInfo;

@interface UseralertDets : NSObject
{
    
}
@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* kpiName;
@property (nonatomic, retain) NSString* testValue;

@end

@interface UserAlertInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, copy) NSString *mainIll;
@property (nonatomic, copy) NSString *doStatusName;

@property (nonatomic, retain) NSString* testDataId;
@property (nonatomic, retain) NSString* testResulId;
@property (nonatomic, retain) NSString* sourceTestDataId;

@property (nonatomic, retain) NSString* uploadTime;     //数据上传时间
@property (nonatomic, retain) NSString* testTime;

@property (nonatomic, assign) NSInteger doStatus;
@property (nonatomic, assign) NSInteger staffId;
@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* doTime;
@property (nonatomic, retain) NSString* doWay;
@property (nonatomic, copy) NSString *opinion;   //其他方式预警处理备注

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* testName;
@property (nonatomic, retain) NSString* sourceKpiCode;

@property (nonatomic, retain) UseralertDets* dataDets;

@property (nonatomic, copy)  NSString  *illDiagnose; //患病 预警跳转联系患者

@property (nonatomic, assign) NSInteger healthyId;

- (NSString*) uploadTimeString;

- (PatientInfo *)convertToPatientInfo;

@end

@interface UserWarningRecord : NSObject
{
    
}
@property (nonatomic, retain) NSString* dealId;
@property (nonatomic, retain) NSString* doDate;
@property (nonatomic, retain) NSString* doWay;
@property (nonatomic, retain) NSString* testValue;

@property (nonatomic, retain) NSString* processTime;    //处理时间
@property (nonatomic, retain) NSString* uploadTime;     //监测数据上传时间
@property (nonatomic, retain) NSString* staffName;      //处理人

@end

//档案详情跳转
@interface ArchivesDetailModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString* sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString* mainIll;

@property (nonatomic, assign) NSInteger healthyId;

@end


@interface UserWarningDetInfo : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *ill;
@property (nonatomic, copy) NSString *kpiCode;
@property (nonatomic, copy) NSString *kpiName;
@property (nonatomic, copy) NSString *testTime;
@property (nonatomic, copy) NSString *warmingTime;
@property (nonatomic, copy) NSString *testValue;
@property (nonatomic, copy) NSString *testDataId;

@end
