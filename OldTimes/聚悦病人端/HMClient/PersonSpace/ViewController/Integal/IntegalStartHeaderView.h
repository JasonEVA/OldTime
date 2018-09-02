//
//  IntegalStartHeaderView.h
//  HMClient
//
//  Created by yinquan on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralModel.h"
/*
 我的积分概要View
 */
@interface IntegalStartSummaryView : UIView

- (void) setIntegralSummaryModel:(IntegralSummaryModel*) model;
@end

@interface IntegalStartHeaderView : UIView
{
    
}

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) IntegalStartSummaryView* summaryView;


- (void) setIntegralSummaryModel:(IntegralSummaryModel*) model;
@end
