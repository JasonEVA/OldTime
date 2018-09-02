//
//  UrineVolumeRecord.h
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface UrineVolumeValue : NSObject
{
    
}
@property (nonatomic, retain) NSString* kpiName;
@property (nonatomic, assign) NSInteger testValue;
@end

@interface UrineVolumeRecord : DetectRecord
{
    
}

@property (nonatomic, retain) UrineVolumeValue* dataDets;
@property (nonatomic, assign) NSInteger urineVolume;
@property (nonatomic, retain) NSString* timeType;

@end

@interface UrineVolumeResult : DetectResult

@property (nonatomic, retain) UrineVolumeValue* dataDets;
@property (nonatomic, assign) NSInteger urineVolume;
@property (nonatomic, retain) NSString* timeType;

@end
