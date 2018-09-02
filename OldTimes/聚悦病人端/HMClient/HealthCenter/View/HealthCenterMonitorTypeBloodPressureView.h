//
//  HealthCenterMonitorTypeBloodPressureView.h
//  HMClient
//
//  Created by Andrew Shen on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthCenterMonitorTypeBloodPressureView : UIView

@property (nonatomic, strong)  UIImageView  *healthLevel; // <##>
@property (nonatomic, strong)  UILabel  *lbHealthLevel; // <##>
@property (nonatomic, strong)  UILabel  *title; // <##>
@property (nonatomic, strong)  UILabel  *value; // <##>
@property (nonatomic, strong)  UILabel  *date; // <##>
@property (nonatomic, strong)  UILabel  *unit; // <##>

@end
