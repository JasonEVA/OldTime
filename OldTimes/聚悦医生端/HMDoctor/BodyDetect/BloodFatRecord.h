//
//  BloodFatRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface BloodFatValue: NSObject
{
    
}

@property (nonatomic, assign) float TC;
@property (nonatomic, assign) float TG;
@property (nonatomic, assign) float LDL_C;
@property (nonatomic, assign) float HDL_C;
@property (nonatomic, assign) float TC_DIVISION_HDL_C;
@end

@interface BloodFatRecord : DetectRecord
{
    
}

@property (nonatomic, retain) BloodFatValue* dataDets;

@end

@interface BloodFatResult : DetectResult

@property (nonatomic, retain) BloodFatValue* dataDets;
@end
