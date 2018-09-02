//
//  ATCheckAttendanceView.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATCheckAttendanceView.h"
#import "ATCheckAttendanceHeaderView.h"
//#import "CCInfoView.h"
#import "ATStaticInfoView.h"

#import "ATSharedMacro.h"
#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"

@interface ATCheckAttendanceView ()

@property (nonatomic, strong) ATCheckAttendanceHeaderView *headerView;
@property (nonatomic, strong) ATStaticInfoView *noInfoView;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation ATCheckAttendanceView

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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataTableView.showsVerticalScrollIndicator = NO;
        [self createHeaderView];
    }
    
    return self;
}

- (void)createHeaderView {
    ATCheckAttendanceHeaderView *headerView = [[ATCheckAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 240)];
    self.dataTableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    [headerView headerViewOfPunchCardBtnClicked:^(NSNumber *timestamp) {
        _block(timestamp);
    }];
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

- (void)showNoInfoView {
    if (!self.noInfoView.superview) {
        self.noInfoView = [[ATStaticInfoView alloc] initWithImage:[UIImage imageNamed:@"img_common_warning_noContent"] andMessage:@"没有内容"];
        self.noInfoView.frame = CGRectMake(0, 240 + 64, self.bounds.size.width, SCREEN_HEIGHT - 240 - 64);
        [self addSubview:self.noInfoView];
    }
}

- (void)hideNoInfoView {
    if (self.noInfoView) {
        [self.noInfoView removeFromSuperview];
        self.noInfoView = nil;
    }
}

- (void)setCurrentTimestamp:(NSNumber *)currentTimestamp {
    self.headerView.currentTimestamp = currentTimestamp;
}

- (void)setIsDesignatedArea:(BOOL)isDesignatedArea {
    self.headerView.isDesignatedArea = isDesignatedArea;
}

- (void)attendanceViewOfGoToPunchCard:(ATCheckAttendanceViewBlock)block
{
    _block = block;
}

@end
