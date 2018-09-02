//
//  BloodSugarDetectRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface BloodSugarDetectValue : NSObject
{
    
}
@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* kpiName;
@property (nonatomic, assign) float testValue;
@property (nonatomic, retain) NSArray* XT_IMGS;

@end

@interface BloodSugarDetectRecord : DetectRecord
{
    
}
@property (nonatomic, retain) BloodSugarDetectValue* dataDets;
@property (nonatomic, assign) float bloodSugar;
@property (nonatomic, retain) NSString* detectTimeName;
@end

@interface BloodSugarDetectResult : DetectResult
{
    
}

@property (nonatomic, retain) BloodSugarDetectValue* dataDets;
@property (nonatomic, assign) float bloodSugar;
@property (nonatomic, retain) NSString* detectTimeName;
@property (nonatomic, retain) NSString* diet;
@end
