//
//  HMWeightHealthClassView.h
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//  PK体重相关阅读view

#import <UIKit/UIKit.h>
@class HealthEducationItem;

@interface HMWeightHealthClassView : UIButton
- (void)fillDataWithModel:(HealthEducationItem *)model;

@end
