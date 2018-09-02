//
//  CommonDeviceDetectHomePageView.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonDeviceDetectHomePageView : UIView

@property(nonatomic,strong) UIImageView *bluetoothConnectIcon;
@property (nonatomic,strong) UIButton *button;

- (void)setDeviceImg:(NSString *)aImage;
- (void)setRemindContent:(NSString *)content;

//血脂界面约束更新
- (void)bloodFatUpdateConstraints;

//血脂测试界面更新
-(void)bloodFatdetectLayoutUpdateConstraints;

//血氧测试界面约束更新
- (void)detectLayoutUpdateConstraints;

@end
