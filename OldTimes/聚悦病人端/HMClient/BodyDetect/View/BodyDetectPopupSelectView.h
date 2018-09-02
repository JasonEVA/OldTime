//
//  BodyDetectPopupSelectView.h
//  HMClient
//
//  Created by lkl on 2017/8/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyDetectPopupSelectView : UIView

- (instancetype)initWithKpiCode:(NSString *)kpiCode;

@property (nonatomic, copy) void(^dataSelectBlock)(NSDictionary *dic);

@end
