//
//  HealthPlanSingleDetectTemplate.h
//  HMDoctor
//
//  Created by yinquan on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPlanSingleDetectTemplateModel : NSObject

@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* name;

@end


@interface HealthPlanSingleDetectSectionModel :NSObject

@property (nonatomic, assign) NSInteger standardId;
@property (nonatomic, retain) NSString* standardName;
@property (nonatomic, retain) NSArray* child;
@end
