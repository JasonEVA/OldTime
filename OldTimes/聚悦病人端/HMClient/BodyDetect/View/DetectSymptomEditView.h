//
//  DetectSymptomEditView.h
//  HMClient
//
//  Created by lkl on 2017/4/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "BodyTemperatureDetectRecord.h"

@interface DetectSymptomEditView : UIView

- (void)setDetectResult:(DetectResult *) detectResult;

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *delButton;

@end
