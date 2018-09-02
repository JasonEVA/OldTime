//
//  HealthPlanMessionInfo.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPlanMessionInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* illName;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *mainIll;

@property (nonatomic, retain) NSString* beginTime;
@property (nonatomic, retain) NSString* endTime;
@property (nonatomic, retain) NSString* healthyName;
@property (nonatomic, retain) NSString* healthyPlanContent;
@property (nonatomic, retain) NSString* healthyPlanTempId;
@property (nonatomic, assign) NSInteger healthyId;

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger approveStaffId;        //指定医生ID

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, copy)  NSString *teamName;
@property (nonatomic, copy)  NSString  *imGroupId; // IM群ID

@end
