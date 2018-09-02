//
//  HealthReportInfo.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthReportInfo : NSObject

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, retain) NSString* beginTime;
@property (nonatomic, retain) NSString* endTime;
@property (nonatomic, retain) NSString* creatTime;
@property (nonatomic, retain) NSString* summarizeTime;

@property (nonatomic, retain) NSString* healthyId;
@property (nonatomic, retain) NSString* healthyReportId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString* statusView;

@property (nonatomic, retain) NSString* reportSummary;
@property (nonatomic, assign) NSInteger summarizeUserId;
@end
