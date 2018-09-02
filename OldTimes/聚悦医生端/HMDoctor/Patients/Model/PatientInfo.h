//
//  PatientInfo.h
//  HMDoctor
//
//  Created by yinquan on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PatientInfo : NSObject
{
    
}

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, retain) NSString* illName;
@property (nonatomic, retain) NSString* testResulId; //从预警传过来的，是UserAlertInfo的参数
@property (nonatomic, copy)  NSString  *illDiagnose; // 患病
@property (nonatomic, retain) NSDictionary* userTestDatas;
@property (nonatomic, assign)  NSInteger  teamId; // jsaon增加
@property (nonatomic, strong) NSString *healthId;    //健康计划ID
@property (nonatomic, assign) NSInteger paymentType; //是否收费  2收费 1免费
@property (nonatomic, copy)  NSString  *imGroupId; // IM群ID
@property (nonatomic, copy)  NSString  *diseaseTitle; //病名
@property (nonatomic) CGFloat orderMoney; // 订单价格

//预警处理提示框
@property (nonatomic, copy) NSString *testName;
@property (nonatomic, copy) NSString *testValue;
@property (nonatomic, copy) NSString *uploadTime;
@property (nonatomic, assign) NSInteger doStatus;
@property (nonatomic, copy) NSString *kpiCode;
@end

@interface PatientGroupInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* teamName;
@property (nonatomic, retain) NSArray<PatientInfo *>* users;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign)  NSInteger  teamId; // andrew增加
@property (nonatomic, assign) BOOL isAllSelected; // Jason添加 是否被全选

@end
