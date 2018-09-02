//
//  DetectRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetectRecord : NSObject

@property (nonatomic, retain) NSString* testDataId;
@property (nonatomic, retain) NSString* sourceTestDataId;
@property (nonatomic, retain) NSString* testTime;

@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* sourceKpiCode;

@property (nonatomic, retain) NSString* userAlertResult;
@property (nonatomic, retain) NSDictionary*  testValue;

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* alertGrade;

- (NSString*) dateStr;
- (NSString*) timeStr;
- (BOOL)isAlertGrade;   //是否为预警数据

@end

@interface DetectResult : DetectRecord
{
    
}

@property (nonatomic, assign) NSInteger surveyId;
@property (nonatomic, retain) NSString* surveyMoudleName;
@property (nonatomic, retain) NSString* userHealthySuggest;
@end
