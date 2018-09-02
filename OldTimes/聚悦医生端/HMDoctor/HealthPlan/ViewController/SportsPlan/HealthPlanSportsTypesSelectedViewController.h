//
//  HealthPlanSportsTypesSelectedViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HealthPlanSportsTypesSelecteHandle)(NSArray* sportsTypes);

@interface HealthPlanSportsTypesSelectedViewController : UIViewController

+ (void) showWithSportsTypes:(NSArray*) sportsTypes
                selectHandle:(HealthPlanSportsTypesSelecteHandle) selectHandle;

- (id) initWithSportsTypes:(NSArray*) sportsTypes
              selectHandle:(HealthPlanSportsTypesSelecteHandle) selectHandle;
@end
