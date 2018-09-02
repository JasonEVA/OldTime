//
//  MainConsoleStatisticsView.h
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainConsoleStatisticsModel.h"

@interface MainConsoleStatisticsView : UIView

@property (nonatomic, assign) BOOL showIncome;

- (void) setMainConsoleStatisticsModel:(MainConsoleStatisticsModel*) statisticsModel;
@end
