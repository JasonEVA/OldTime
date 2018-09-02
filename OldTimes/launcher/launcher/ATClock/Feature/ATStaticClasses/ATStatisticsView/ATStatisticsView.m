//
//  ATStatisticsView.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATStatisticsView.h"
#import "ATStaticHeadView.h"

#import "ATSharedMacro.h"

static const CGFloat staticHeadHeight = 215.0f;

@interface  ATStatisticsView()<ATStaticHeadViewDelegate>

@end

@implementation ATStatisticsView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.dataTableView.contentInset = UIEdgeInsetsMake(staticHeadHeight, 0, 0, 0);
        ATStaticHeadView *headView = [[ATStaticHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, staticHeadHeight)];
        self.normalLabelNum = headView.normalLabelNum;
        self.unnormalLabelNum = headView.unnormalLabelNum;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy年MM月";
        NSString *string = [fmt stringFromDate:[NSDate date]];
        headView.dateLabel.text = string;
        
        headView.delegate = self;
        [self addSubview:headView];

    }
    return self;
}

#pragma mark - ATStaticHeadViewDelegate
- (void)changeDate:(UILabel *)dateLabel isAddMouth:(BOOL)isAdd nextButton:(UIButton *)nextButton {

    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDate:isAddMouth:nextButton:)]) {
        [self.delegate changeDate:dateLabel isAddMouth:isAdd nextButton:nextButton];
    }

}



@end
