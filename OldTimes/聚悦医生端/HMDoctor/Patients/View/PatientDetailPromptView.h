//
//  PatientDetailPromptView.h
//  HMDoctor
//
//  Created by lkl on 2017/7/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientDetailPromptView : UIView

@end


@interface PatientDetailNavigationView : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIButton *historyMsgBtn;
@property (nonatomic, strong) UIButton *archiveBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@end
