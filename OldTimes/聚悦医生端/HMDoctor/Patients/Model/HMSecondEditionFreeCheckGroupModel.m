//
//  HMSecondEditionFreeCheckGroupModel.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionFreeCheckGroupModel.h"
#import "MJExtension.h"

@implementation HMSecondEditionFreeCheckGroupModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"groupData" : [HMSecondEditionFreePatientInfoCheckModel class]
             };
    
}
@end
