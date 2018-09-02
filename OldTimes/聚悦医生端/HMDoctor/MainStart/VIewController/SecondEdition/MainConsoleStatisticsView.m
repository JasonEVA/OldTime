//
//  MainConsoleStatisticsView.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleStatisticsView.h"
#import "HMFEPatientListEnum.h"

@interface MainConsoleStatisticsCell : UIView

@property (nonatomic, readonly) UILabel* nameLable;
@property (nonatomic, readonly) UILabel* valueLable;

@end

@implementation MainConsoleStatisticsCell

@synthesize nameLable = _nameLable;
@synthesize valueLable = _valueLable;

- (id) init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) setName:(NSString*) name value:(NSString*) value
{
    [self.nameLable setText:name];
    [self.valueLable setText:value];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(5);
        make.width.lessThanOrEqualTo(self);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.valueLable.mas_bottom).with.offset(6);
        make.width.lessThanOrEqualTo(self);
    }];
}


#pragma mark - settingAndGetting
- (UILabel*) nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        [self addSubview:_nameLable];
        [_nameLable setFont:[UIFont systemFontOfSize:14]];
        [_nameLable setTextColor:[UIColor whiteColor]];
    }
    return _nameLable;
}

- (UILabel*) valueLable
{
    if (!_valueLable) {
        _valueLable = [[UILabel alloc] init];
        [self addSubview:_valueLable];
        [_valueLable setFont:[UIFont boldSystemFontOfSize:32]];
        [_valueLable setTextColor:[UIColor whiteColor]];
    }
    return _valueLable;
}

@end

@interface MainConsoleStatisticsView ()

@property (nonatomic, readonly) MainConsoleStatisticsCell* freePatientCell;
@property (nonatomic, readonly) MainConsoleStatisticsCell* chargePatientCell;
@property (nonatomic, readonly) MainConsoleStatisticsCell* patientNewCell;
@property (nonatomic, readonly) MainConsoleStatisticsCell* incomeCell;
@property (nonatomic, readonly) MainConsoleStatisticsCell* groupCell;


@end

@implementation MainConsoleStatisticsView

@synthesize freePatientCell = _freePatientCell;
@synthesize chargePatientCell = _chargePatientCell;
@synthesize patientNewCell = _patientNewCell;
@synthesize incomeCell = _incomeCell;
@synthesize groupCell = _groupCell;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.freePatientCell setName:@"免费用户" value:@"0"];
        [self.chargePatientCell setName:@"收费用户" value:@"0"];
        [self.patientNewCell setName:@"本周入组" value:@"0"];
        [self.groupCell setName:@"集团用户" value:@"0"];

    }
    return self;
}

- (void) setMainConsoleStatisticsModel:(MainConsoleStatisticsModel*) statisticsModel
{
    [self.freePatientCell setName:@"免费用户" value:[NSString stringWithFormat:@"%ld", statisticsModel.freePatientCount]];
    [self.chargePatientCell setName:@"收费用户" value:[NSString stringWithFormat:@"%ld", statisticsModel.chargePatientCount]];
    [self.patientNewCell setName:@"本周入组" value:[NSString stringWithFormat:@"%ld", statisticsModel.newPatientCount]];
    [self.groupCell setName:@"集团用户" value:[NSString stringWithFormat:@"%ld", statisticsModel.blocPatientCount]];

    [self.incomeCell setName:@"收益" value:[NSString stringWithFormat:@"%ld", (NSInteger)statisticsModel.income]];


//    if ([CommonFuncs isInteger:statisticsModel.income])
//    {
//        [self.incomeCell setName:@"收益" value:[NSString stringWithFormat:@"%ld", (NSInteger)statisticsModel.income]];
//    }
//    else
//    {
//        [self.incomeCell setName:@"收益" value:[NSString stringWithFormat:@"%.2f", statisticsModel.income]];
//    }
    
    [self setHidden:NO];
}

- (void)thisWeekClick {
    [HMViewControllerManager createViewControllerWithControllerName:@"HMThisWeekIntoGroupViewController" ControllerObject:nil];
}

- (void)chargeClick {
    // 收费点击
    [HMViewControllerManager createViewControllerWithControllerName:@"HMFEPatientListViewController" ControllerObject:@(HMFEPatientListViewType_Package)];
}

- (void)groupClick {
    // 集团用户点击
    [HMViewControllerManager createViewControllerWithControllerName:@"HMFEGroupPatientListViewController" ControllerObject:nil];
}

- (void)freeClick {
    // 免费用户点击
     [HMViewControllerManager createViewControllerWithControllerName:@"HMFEPatientListViewController" ControllerObject:@(HMFEPatientListViewType_Free)];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.groupCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
    }];
    
    [self.chargePatientCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.groupCell.mas_right);
        make.width.equalTo(self.groupCell);
    }];
    
    [self.freePatientCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.chargePatientCell.mas_right);
        make.width.equalTo(self.groupCell);
        
    }];
    
    [self.patientNewCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.freePatientCell.mas_right);
        make.width.equalTo(self.groupCell);
    }];
    
    [self.incomeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.patientNewCell.mas_right);
        make.width.mas_equalTo(@0);
    }];
}


#pragma mark - settingAndGetting
- (MainConsoleStatisticsCell*) freePatientCell
{
    if (!_freePatientCell) {
        _freePatientCell = [[MainConsoleStatisticsCell alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(freeClick)];
        [_freePatientCell addGestureRecognizer:tap];
        [self addSubview:_freePatientCell];
    }
    return _freePatientCell;
}

- (MainConsoleStatisticsCell*) chargePatientCell
{
    if (!_chargePatientCell) {
        _chargePatientCell = [[MainConsoleStatisticsCell alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chargeClick)];
        [_chargePatientCell addGestureRecognizer:tap];
        [self addSubview:_chargePatientCell];
    }
    return _chargePatientCell;
}

- (MainConsoleStatisticsCell*) groupCell
{
    if (!_groupCell) {
        _groupCell = [[MainConsoleStatisticsCell alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupClick)];
        [_groupCell addGestureRecognizer:tap];
        [self addSubview:_groupCell];
    }
    return _groupCell;
}

- (MainConsoleStatisticsCell*) patientNewCell
{
    if (!_patientNewCell) {
        _patientNewCell = [[MainConsoleStatisticsCell alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thisWeekClick)];
        [_patientNewCell addGestureRecognizer:tap];
        [self addSubview:_patientNewCell];
    }
    return _patientNewCell;
}

- (MainConsoleStatisticsCell*) incomeCell
{
    if (!_incomeCell) {
        _incomeCell = [[MainConsoleStatisticsCell alloc] init];
        [self addSubview:_incomeCell];
    }
    return _incomeCell;
}

- (void) setShowIncome:(BOOL)showIncome
{
    if (showIncome == _showIncome) {
        return;
    }
    
    _showIncome = showIncome;
    
    [self.incomeCell mas_updateConstraints:^(MASConstraintMaker *make) {
        if (showIncome) {
            make.width.equalTo(self.patientNewCell);
        }
        else
        {
            make.width.mas_equalTo(@0);
        }
    }];
}


@end
