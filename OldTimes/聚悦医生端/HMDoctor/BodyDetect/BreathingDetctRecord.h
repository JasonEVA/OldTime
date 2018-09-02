//
//  BreathingDetctRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface BreathingDetctValue : NSObject
{
    
}
@property (nonatomic, assign) NSInteger HX_SUB;
@end

@interface BreathingDetctRecord : DetectRecord
{
    
}

@property (nonatomic, retain) BreathingDetctValue* dataDets;
@property (nonatomic, assign) NSInteger breathrate;
@end

@interface BreathingDetctResult : DetectResult

@property (nonatomic, retain) BreathingDetctValue* dataDets;
@property (nonatomic, assign) NSInteger breathrate;
@property (nonatomic, retain) NSString* symptom;
@end
