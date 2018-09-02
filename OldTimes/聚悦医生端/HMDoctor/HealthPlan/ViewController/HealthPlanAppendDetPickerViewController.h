//
//  HealthPlanAppendDetPickerViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/31.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HealthPlanDetModel : NSObject

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* title;

@end

typedef void(^HealthPlanAppendDetPickHandle)(HealthPlanDetModel* model);

@interface HealthPlanAppendDetPickerViewController : UIViewController

+ (void) showWithExistedDets:(NSArray*) existDets pickHandle:(HealthPlanAppendDetPickHandle) handle;

@end
