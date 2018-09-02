//
//  SEMainStartTodayStepsView.h
//  HMClient
//
//  Created by lkl on 2017/10/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEMainStartTodayStepsView : UIView

- (void)syncBraceletData;

@end

@interface SEMainStartSyncDataView : UIView
@property (nonatomic, strong) UIActivityIndicatorView *viewIndicator;    // 旋转指示器
@end
