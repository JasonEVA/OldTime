//
//  BloodPressurePeriodSelectViewController.h
//  HMClient
//
//  Created by lkl on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BloodPressureThriceDetectModel;
typedef void(^SetupSelectSelectBlock)(BloodPressureThriceDetectModel* model);

@interface BloodPressurePeriodSelectViewController : UIViewController

+ (BloodPressurePeriodSelectViewController *) createWithParentViewController:(UIViewController*) parentviewcontroller setUpType:(NSString *)setUpType selectblock:(SetupSelectSelectBlock)block;

@property (nonatomic, copy) SetupSelectSelectBlock selectblock;
@property (nonatomic, copy) NSString *type;

- (void)createTableView;

@end
