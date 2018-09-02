//
//  BloodPresureDeviceDetectLayoutView.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPresureDeviceDetectLayoutView : UIView

@property(nonatomic,strong) UIImageView *heartImage;
@property(nonatomic,strong) UIButton *measureButton;

- (void)setHeartValue:(NSString *)heartValue;
- (void)setHeartImageAnimationPlay;

@end
