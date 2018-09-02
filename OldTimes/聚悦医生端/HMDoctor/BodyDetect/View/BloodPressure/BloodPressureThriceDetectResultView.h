//
//  BloodPressureThriceDetectResultView.h
//  HMClient
//
//  Created by lkl on 2017/6/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodPressureDetectRecord.h"

@interface BloodPressureThriceDetectResultView : UIView

- (void) setDetectResult:(BloodPressureDetectResult*) result;

@end

@interface BloodPressureThriceDetectDataListView : UIView

- (void) setDetectResult:(BloodPressureDetectResult*) result;

@end
