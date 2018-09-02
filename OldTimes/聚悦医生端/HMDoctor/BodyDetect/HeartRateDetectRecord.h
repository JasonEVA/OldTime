//
//  HeartRateDetectRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface HeartRateDetectValue : NSObject
{
    
}
@property (nonatomic, assign) NSInteger XL_SUB;
@property (nonatomic, assign) NSInteger XL_OF_XD;
@property (nonatomic, retain) NSString *kpi;
@property (nonatomic, strong) NSString *PR;
@property (nonatomic, strong) NSString *RR;
@property (nonatomic, strong) NSString *QRS;
@property (nonatomic, strong) NSString *symptom;

@property (nonatomic, retain) NSArray *bitMapDatas;

@end

@interface HeartRateDetectRecord : DetectRecord
{
    
}
@property (nonatomic, retain) HeartRateDetectValue* dataDets;

@property (nonatomic, assign) NSInteger heartRate;


@end

@interface HeartRateDetectResult : DetectResult
{
    
}
@property (nonatomic, retain) HeartRateDetectValue* dataDets;
@property (nonatomic, assign) NSInteger heartRate;
@property (nonatomic, strong) NSString *symptom;

@property (nonatomic, assign) BOOL isXD; //区分心电、心率
@end
