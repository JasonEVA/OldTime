//
//  PlantformConfig.m
//  HealthMgrDoctor
//
//  Created by yinqaun on 16/1/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PlantformConfig.h"

//#define kPlantform_JuYue
//#define kPlantform_ChongYi
//#define kPlantform_XiNan
#define kPlantformCallType          1
#define kPlantformCode              @"ALL"


#ifdef kPlantform_JuYue
#define kPlantformCallType          1
#define kPlantformCode              @"ALL"
#endif

#ifdef kPlantform_ChongYi
#define kPlantformCallType          7
#define kPlantformCode              @"CYPT"
#endif

#ifdef kPlantform_XiNan
#define kPlantformCallType          11
#define kPlantformCode              @"XNPT"
#endif

@implementation PlantformConfig

+ (NSInteger) calltype
{
    return kPlantformCallType;
}

+ (NSString*) plantformCode
{
    return kPlantformCode;
}

+ (NSString*) mainAdvertiseCode
{
    NSString* advertiseCode = @"HomePage2.0_ios_jy";
#ifdef kPlantform_ChongYi
    advertiseCode = @"HomePage2.0_ios_cy";
#endif
#ifdef kPlantform_XiNan
    advertiseCode = @"HomePage2.0_ios_xn";
#endif
    return advertiseCode;
}

@end
