//
//  HealthPlanDetModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HealthPlanStatus) {
    HealthPlan_UnMade = 1,      //待制定
    HealthPlan_UnConfirm,       //待确认
    HealthPlan_UnAdjust,        //待调整
    HealthPlan_Finished = 5,    //已完成
    HealthPlan_Expired,         //已过期
    HealthPlan_Executing,       //执行中
    
};

@interface HealthPlanDetailModel : NSObject

@property (nonatomic, retain) NSString* beginTime;
@property (nonatomic, retain) NSString* endTime;
@property (nonatomic, retain) NSString* templateName;
@property (nonatomic, retain) NSString* healthyId;
@property (nonatomic, retain) NSString* healthyPlanTempId;

@property (nonatomic, assign) NSString* status;
@property (nonatomic, retain) NSString* statusName;

@property (nonatomic, retain) NSArray* dets;

@property (nonatomic, retain) NSString* approveStaffId;
@property (nonatomic, retain) NSString* approveStaffName;
@property (nonatomic, retain) NSString* approveTime;

@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, retain) NSString* createUserId;
@property (nonatomic, retain) NSString* createUserName;

@property (nonatomic, retain) NSString* userIdStr;

@property (nonatomic, retain) NSString* versionNo;

@end

@interface HealthPlanDetailSectionModel : NSObject

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* planId;

@property (nonatomic, retain) NSArray* criterias;
@property (nonatomic, retain) NSString* orgGroupCode;
@property (nonatomic, retain) NSString* templateDetId;
@property (nonatomic, retain) NSString* toTempId;

@property (nonatomic, readonly) NSString* healthyPlanDetDesc;

- (NSString*) titleWithCode;

- (BOOL) planDetIsValid;

- (BOOL) planDetIsValidWithErrorAlert;

@end
