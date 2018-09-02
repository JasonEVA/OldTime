//
//  PEFDetectRecord.h
//  HMClient
//
//  Created by lkl on 2017/6/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@interface PEFDetectRecordsValue : NSObject

@property (nonatomic, assign) NSInteger FLSZ_SUB;

@end

@interface PEFDetectRecord : DetectRecord

@property (nonatomic, retain) PEFDetectRecordsValue *dataDets;
@property (nonatomic, copy) NSString *testTimeName;

@end

@interface PEFDetectResult : DetectResult

@end
