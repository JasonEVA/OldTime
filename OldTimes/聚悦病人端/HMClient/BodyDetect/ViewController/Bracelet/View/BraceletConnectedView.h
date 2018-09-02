//
//  BraceletConnectedView.h
//  HMClient
//
//  Created by lkl on 2017/9/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BraceletDeviceInfo.h"

@interface BraceletConnectedView : UIView

- (void)setBatteryInfo:(NSString *)battery;
- (void)setBraceletDeviceInfo:(BraceletDeviceInfo *)deviceInfo;
- (void)setBraceletConnectDeviceInfo:(BraceletConnectDeviceInfo *)connectInfo;

@end


typedef void(^Block)();

@interface BraceletDisConnectedView : UIView

@property (nonatomic, copy) Block confrimBlock;

@end
