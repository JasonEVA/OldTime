//
//  HealthPlanSubTemplateModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPlanSubTemplateModel : NSObject

@property (nonatomic, retain) NSString* templateName;
@property (nonatomic, retain) NSString* standardName;

@property (nonatomic, assign) NSInteger sportsTimes;
@property (nonatomic, retain) NSArray* sportsType;
@end
