//
//  AssessmentMessionModel.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentMessionModel.h"

@implementation AssessmentMessionModel

@end


@implementation AssessmentRecordModel

@end

@implementation AssessmentCategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"details" : [AssessmentCategoryDetailsModel class]
             };
}

@end

@implementation AssessmentCategoryDetailsModel

@end


@implementation AssessmentTemplateModel


@end

