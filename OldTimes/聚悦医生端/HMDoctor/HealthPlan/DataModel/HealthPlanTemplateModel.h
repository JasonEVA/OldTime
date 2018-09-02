//
//  HealthPlanTemplateModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPlanTemplateModel : NSObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* id;

@end

@interface HealthPlanDepartmentTemplateModel : NSObject

@property (nonatomic, retain) NSString* standardName;
@property (nonatomic, retain) NSString* standardId;
@property (nonatomic, retain) NSArray* child;

@end
