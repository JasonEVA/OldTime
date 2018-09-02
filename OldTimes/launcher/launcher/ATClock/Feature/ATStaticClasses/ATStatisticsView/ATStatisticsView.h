//
//  ATStatisticsView.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATTableView.h"

@protocol ATStatisticsViewDelegate <NSObject>

@optional
- (void)changeDate:(UILabel *)dateLabel isAddMouth:(BOOL) isAdd nextButton:(UIButton *)nextButton;

@end


@interface ATStatisticsView : ATTableView

@property (nonatomic, weak) id<ATStatisticsViewDelegate> delegate;

@property (nonatomic, strong) UILabel *normalLabelNum;
@property (nonatomic, strong) UILabel *unnormalLabelNum;

@end
