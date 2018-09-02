//
//  DealUserAlertOtherwayView.h
//  HMDoctor
//
//  Created by lkl on 2017/9/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlertInfo.h"
#import "PlaceholderTextView.h"

@interface DealUserAlertOtherwayView : UIView

@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) PlaceholderTextView *txtView;

@end

@interface DealUserAlertInfoView : UIView

- (void)setUserAlertInfo:(UserWarningDetInfo *)alert;

@end
