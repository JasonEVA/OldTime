//
//  HMSelectPatientThirdEditionBottomView.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第三版患者选择底部view

#import <UIKit/UIKit.h>

@protocol HMSelectPatientThirdEditionBottomViewDelegate <NSObject>

- (void)HMSelectPatientThirdEditionBottomViewDelegateCallBack_buttonClick:(UIButton *)button;

@end

@interface HMSelectPatientThirdEditionBottomView : UIView
@property (nonatomic, weak) id<HMSelectPatientThirdEditionBottomViewDelegate> delegate;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *titelLb;

@end
