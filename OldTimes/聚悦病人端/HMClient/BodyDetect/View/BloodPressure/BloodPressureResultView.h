//
//  BloodPressureResultView.h
//  HMClient
//
//  Created by lkl on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BloodPressureDetectRecord.h"

@interface BloodPressureValueView : UIView

- (void)setName:(NSString *)aName subName:(NSString *)subName unit:(NSString*)unit;

//更新布局
- (void)updateViewConstraints;

@end

@interface BloodPressureResultView : UIView

- (void) setDetectResult:(BloodPressureDetectResult*) result;

@end

