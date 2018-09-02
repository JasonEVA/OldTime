//
//  BreathingSymptomView.h
//  HMClient
//
//  Created by lkl on 16/7/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreathingDetctRecord.h"

@interface BreathingSymptomView : UIView

- (void) setDetectResult:(DetectResult*) detectResult;
@property(nonatomic, readonly) UIButton *editButton;
@property(nonatomic, readonly) UIButton *deleteButton;
@property(nonatomic, retain) UILabel* lbResult;

@end
