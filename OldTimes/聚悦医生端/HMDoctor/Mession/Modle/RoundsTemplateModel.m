//
//  RoundsTemplateModel.m
//  HMDoctor
//
//  Created by yinquan on 16/9/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsTemplateModel.h"

@implementation RoundsTemplateModel

@end

@implementation RoundsTemplateWithUserModel

- (id) initWithRoundsTemplateModel:(RoundsTemplateModel*) category
{
    self = [super init];
    if (self)
    {
        self.templateId = category.templateId;
        self.templateName = category.templateName;
        
    }
    return self;
}

@end

@implementation RoundsTemplateCategoryModel


@end

@implementation RoundsTemplateCategoryWithUserModel

- (id) initWithRoundsTemplateCategoryModel:(RoundsTemplateCategoryModel*) category
{
    self = [super init];
    if (self)
    {
        self.categoryId = category.categoryId;
        self.categoryName = category.categoryName;
        self.deptId = category.deptId;
    }
    return self;
}
@end

@implementation RoundsTemplateCategoryListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"details" : [RoundsTemplateCategoryModel class]
             };
}
@end
