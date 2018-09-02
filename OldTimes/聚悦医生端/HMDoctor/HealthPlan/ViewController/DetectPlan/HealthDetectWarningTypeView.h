//
//  HealthDetectWarningTypeView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HealthDetectWarningTypeView : UIView

@property (nonatomic, strong) UIControl* typeControl;

- (void) setWarningType:(NSString*) typeString;
@end
