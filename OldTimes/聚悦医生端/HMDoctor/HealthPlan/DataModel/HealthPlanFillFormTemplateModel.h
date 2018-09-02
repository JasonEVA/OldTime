//
//  HealthPlanFillFormTemplateModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPlanFillFormTemplateModel : NSObject

@property (nonatomic, assign) NSInteger surveyMoudleId;
@property (nonatomic, retain) NSString* surveyMoudleName;

@end

@interface HealthPlanFillFormTemplateSection :NSObject

@property (nonatomic, assign) NSInteger standardId;
@property (nonatomic, retain) NSString* standardName;
@property (nonatomic, retain) NSArray* child;
@end
