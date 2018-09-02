//
//  CoordinationSelectContactsBaseViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//  选人baseView

#import "HMBaseViewController.h"
#import "HMBaseNavigationViewController.h"
#import "SelectContactTabbarView.h"

@interface CoordinationSelectContactsBaseViewController : HMBaseViewController
@property (nonatomic, strong)  UIBarButtonItem  *rightItem; // <##>
@property (nonatomic, strong)  SelectContactTabbarView  *selectView; // <##>
@property (nonatomic, strong)  HMBaseViewController  *containerVC; // <##>
@property (nonatomic, strong)  HMBaseNavigationViewController  *navi; // <##>
@property (nonatomic, copy)  NSString  *rightItemTitle; // <##>
@property (nonatomic)  BOOL  atLeastTwoPeople; // <##>

// ritghtItem事件
- (void)rightItemEvent;

- (void)configRightItemTitle:(NSString *)title;
@end
