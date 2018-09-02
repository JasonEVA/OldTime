//
//  BodyTemperatureDetectRecord.h
//  HMClient
//
//  Created by yinquan on 17/4/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface BodyTemperatureValue : NSObject

@property (nonatomic, retain) NSString* TEM_SUB;

@end

@interface BodyTemperatureDetectRecord : DetectRecord

@property (nonatomic, retain) BodyTemperatureValue* dataDets;

@property (nonatomic, readonly) NSString* temperature;

@end

@interface  BodyTemperatureDetectResult : DetectResult

@property (nonatomic, retain) BodyTemperatureValue* dataDets;
@property (nonatomic, readonly) NSString* temperature;
@property (nonatomic,copy) NSString *symptom;

@end
