//
//  HealthPlanReviewIndicesModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPlanReviewIndicesModel : NSObject

@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* name;

@end

@interface HealthPlaneviewIndicesSection :NSObject

@property (nonatomic, assign) NSInteger standardId;
@property (nonatomic, retain) NSString* standardName;
@property (nonatomic, retain) NSArray* child;
@end
