//
//  BloodOxygenationRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface BloodOxygenationValue : NSObject
{
    
}
@property (nonatomic, assign) NSInteger OXY_SUB;
@property (nonatomic, assign) NSInteger PULSE_RATE;
@property (nonatomic, assign) NSInteger PI_VAL;
@end

@interface BloodOxygenationRecord : DetectRecord
{
    
}

@property (nonatomic, retain) BloodOxygenationValue* dataDets;

@end

@interface BloodOxygenationResult : DetectResult
{
    
}

@property (nonatomic, retain) BloodOxygenationValue* dataDets;
@end
