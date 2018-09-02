//
//  DealUserAlertPromptView.h
//  HMDoctor
//
//  Created by lkl on 2017/7/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealUserAlertPromptView : UIView

//背景视图
@property(nonatomic, strong) UIView *bgView;
//警告图标
@property(nonatomic, strong) UIImageView *warningIcon;
//内容文本
@property(nonatomic, strong) UILabel *contenLabel;

//定义一个Block 回调函数
@property(nonatomic, copy) void(^returnsAnEventBlock)();

- (void)showPromptWithViewController:(UIViewController *)viewControllow prompt:(NSString *)prompt;

@end
