//
//  PersonStaffDescriptionUpdateViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/7/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceholderTextView;

@interface PersonStaffDescriptionUpdateViewController : UIViewController

@property (nonatomic, readonly) PlaceholderTextView* inputTextView;
@property (nonatomic, readonly) UIButton* updateButton;

@end

@interface PersonStaffDescriptionGoodAtUpdateViewController : PersonStaffDescriptionUpdateViewController

@end

@interface PersonStaffDescriptionSummaryUpdateViewController : PersonStaffDescriptionUpdateViewController

@end
