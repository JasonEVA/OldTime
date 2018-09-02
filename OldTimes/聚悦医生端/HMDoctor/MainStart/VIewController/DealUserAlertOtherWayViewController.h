//
//  DealUserAlertOtherWayViewController.h
//  HMDoctor
//
//  Created by lkl on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "PlaceholderTextView.h"

typedef void(^DealUserAlertOtherWayVCDisMiss)(NSString *str);

@interface DealUserAlertOtherWayViewController : HMBasePageViewController

@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) PlaceholderTextView *txtView;

- (instancetype)initWithjumpToOtherWayVC:(DealUserAlertOtherWayVCDisMiss)disMisssBlock;

@end
