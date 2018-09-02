//
//  IMApplicationConfigure.m
//  MintcodeIMDemo
//
//  Created by williamzhang on 16/3/17.
//  Copyright © 2016年 williamzhang. All rights reserved.
//

#import "IMApplicationConfigure.h"

//聚悦平台
#ifdef kPlantform_JuYue
#ifdef YuYouNetowrk

NSString *const im_task_uid     = @"workappidtest@APP";

#else

NSString *const im_task_uid     = @"WorkTask@APP";

#endif

#endif

