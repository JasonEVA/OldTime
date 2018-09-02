//
//  BodyWeightDetectRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface BodyWeightDetectValue : NSObject
{
    
}
@property (nonatomic, assign) float TZ_SUB;
@property (nonatomic, assign) float SG_OF_TZ;
@property (nonatomic, assign) float TZ_BMI;
@end

@interface BodyWeightDetectRecord : DetectRecord
{
    
}
@property (nonatomic, retain) BodyWeightDetectValue* dataDets;
@property (nonatomic, assign) float bodyHeight;

@property (nonatomic, assign) float bodyBMI;

@end

@interface BodyWeightDetectResult : DetectResult
{
    
}

@property (nonatomic, retain) BodyWeightDetectValue* dataDets;
@property (nonatomic, assign) float bodyHeight;

@property (nonatomic, assign) float bodyBMI;
@end
