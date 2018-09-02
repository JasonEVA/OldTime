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
#define kPlantformCallType          3
#define kPlantformCode              @"ALL"


#ifdef kPlantform_JuYue
#define kPlantformCallType          3
#define kPlantformCode              @"ALL"
#endif

#ifdef kPlantform_ChongYi
#define kPlantformCallType          9
#define kPlantformCode              @"CYPT"
#endif

#ifdef kPlantform_XiNan
#define kPlantformCallType          13
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

@end
