//
//  HealthPlanSummaryOperateView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HealthPlanSummaryOperateDelegate <NSObject>

- (void) operateButtonClicked:(EHealthPlanOperation) operate;

@end

@interface HealthPlanSummaryOperateView : UIView

@property (nonatomic, readonly) NSArray* operationButtons;
@property (nonatomic, weak) id<HealthPlanSummaryOperateDelegate> delegate;

- (void) setOpeartions:(NSArray*) opeartions;

@end
