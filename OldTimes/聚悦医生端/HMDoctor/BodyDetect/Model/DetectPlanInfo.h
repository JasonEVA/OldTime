//
//  DetectPlanInfo.h
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetectPlanInfo : NSObject

@property (nonatomic, retain) NSString* KPI_CODE;
@property (nonatomic, assign) NSInteger STATUS;
@property (nonatomic, retain) NSString* EXC_TIME;
@property (nonatomic, retain) NSString* TEST_ID;
@property (nonatomic, retain) NSString* SOURCE_KPI_CODE;

@end
