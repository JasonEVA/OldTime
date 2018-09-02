//
//  BloodPressureDetectRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetectRecord.h"

@interface BloodPressureValue : NSObject
{
    
}
@property (nonatomic, assign) NSInteger SSY;        //收缩压
@property (nonatomic, assign) NSInteger SZY;        //舒张压
@property (nonatomic, assign) NSInteger XL_OF_XY;   //心率
@end

@interface BloodPressureDetectRecord : DetectRecord
{
    
}

@property (nonatomic, retain) BloodPressureValue* dataDets;
@property (nonatomic, retain) NSString* testCount;
@end


@interface BloodPressureSymptomModel : NSObject

@property (nonatomic, copy) NSString *symptomId;
@property (nonatomic, copy) NSString *symptomName;

@end

//历次血压值
@interface BloodPressureDataModel : NSObject

@property (nonatomic, copy) NSArray *detList;
@property (nonatomic, copy) NSString *testTime;
@property (nonatomic, copy) NSString *testDataId;

@end

@interface BloodPressureDataValue : NSObject

@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* testValue;

@end

@interface BloodPressureDetectResult : DetectResult
{
    
}
@property (nonatomic, retain) BloodPressureValue* dataDets;
@property (nonatomic, retain) NSString* testCount;
@property (nonatomic, copy) NSArray *symptomList;
@property (nonatomic, copy) NSString *testTimeName;
@property (nonatomic, copy) NSArray *xyTestDataVoList;    //历次血压值

@property (nonatomic, retain) NSString* testEnvId;
@property (nonatomic, retain) NSString* testEnvName;

@end
