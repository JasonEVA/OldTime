//
//  NewbieGuideBaseSubViewController.h
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//  引导页基类

#import "HMBaseViewController.h"

typedef void(^NewbieGuideSkipCompletion)();
typedef void(^NewbieGuidePushNextCompletion)(NSString *currentClassName);
@interface NewbieGuideBaseSubViewController : HMBaseViewController
@property (nonatomic, strong, readonly)  UIImageView  *backgroundImageView; // <##>

#pragma mark - 子类可调用
// 配置背景图片
- (void)configBackgroundImageView:(NSString *)imageName;
// 隐藏跳过按钮
- (void)hideSkipButton:(BOOL)hide;
// 滚轮滚动完毕
- (void)pickerViewScrollComplete;

#pragma mark - 可重载方法
// 跳过按钮点击事件
- (void)skipButtonAction;
// 背景点击事件
- (void)backgroundImageViewClicked;

#pragma mark - 接口方法
- (void)addNotiSkipCompletion:(NewbieGuideSkipCompletion)skipCompletion;
- (void)addPushNextCompletion:(NewbieGuidePushNextCompletion)pushNextCompletion;


@end
