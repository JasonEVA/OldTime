//
//  HMPopupSelectView.h
//  HMDoctor
//
//  Created by lkl on 2017/6/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMPopupSelectView : UIView

- (instancetype)initWithKpiCode:(NSString *)kpiCode;

@property (nonatomic, copy) void(^dataSelectBlock)(NSDictionary *dic);

@end
