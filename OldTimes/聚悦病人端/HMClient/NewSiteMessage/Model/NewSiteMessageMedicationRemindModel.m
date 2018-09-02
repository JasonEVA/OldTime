//
//  NewSiteMessageMedicationRemindModel.m
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMedicationRemindModel.h"
#import "MJExtension.h"

@implementation NewSiteMessageMedicationRemindModel
+ (NSDictionary *)objectClassInArray {
    return @{@"drugList" : [NewSiteMessageDrugModel class]};
}
@end
