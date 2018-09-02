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

@property (nonatomic, retain) NSString* beginTime;
@property (nonatomic, retain) NSString* endTime;
@property (nonatomic, retain) NSString* healthyName;
@property (nonatomic, retain) NSString* healthyPlanContent;
@property (nonatomic, retain) NSString* healthyPlanTempId;
@property (nonatomic, assign) NSInteger healthyId;

@property (nonatomic, assign) NSInteger status;
@end
