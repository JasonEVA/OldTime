//
//  ATDailyAttendanceView.m
//  Clock
//
//  Created by SimonMiao on 16/7/26.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATDailyAttendanceView.h"

#import "UIColor+ATHex.h"
#import "ATSharedMacro.h"
#import "UILabel+ATCreate.h"

@interface ATDailyAttendanceView ()

@property (nonatomic, strong) UIView *footerView;

@end

@implementation ATDailyAttendanceView

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 240 - 64)];
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 10, 10)];
        circleView.backgroundColor = [UIColor at_blueColor];
        circleView.layer.cornerRadius = 5;
        circleView.layer.masksToBounds = YES;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 25, 0.5, SCREEN_HEIGHT - 240 - 20 - 64)];
        lineView.backgroundColor = [UIColor at_lightGrayColor];
        
        UILabel *titleLab = [UILabel at_createLabWithText:@"未打卡" fontSize:15.0 titleColor:[UIColor at_blackColor]];
        titleLab.frame = CGRectMake(CGRectGetMaxX(circleView.frame) + 20, 10, 50, 15);
        
        [_footerView addSubview:circleView];
        [_footerView addSubview:lineView];
        [_footerView addSubview:titleLab];
    }
    
    return _footerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (void)showFooterView {
    if (!self.footerView.superview) {
        self.dataTableView.tableFooterView = self.footerView;
    }
    self.footerView.hidden = NO;
}

- (void)hideFooterView {
    if (_footerView) {
        self.footerView.hidden = YES;
    }
}

@end
