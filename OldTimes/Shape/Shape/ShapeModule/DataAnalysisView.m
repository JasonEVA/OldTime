//
//  DataAnalysisView.m
//  Shape
//
//  Created by Andrew Shen on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "DataAnalysisView.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "PeriodSelectView.h"
#import "AnalysisMuscleDataTableViewCell.h"
#import "RadarChartView.h"
#import "DateUtil.h"
#import "DBUnifiedManager.h"
#import "MuscleModel.h"

static NSInteger const kPeriodInterval = 7;
static NSString *const kDateFormat = @"YYYY.MM.dd";
@interface DataAnalysisView()<UITableViewDelegate,UITableViewDataSource,PeriodSelectViewDelegate>
@property (nonatomic, strong)  UIImageView  *background; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  PeriodSelectView  *periodSelectView; // <##>
@property (nonatomic, strong)  RadarChartView *chartView; // <##>
@property (nonatomic, strong)  NSDate  *beginDate; // 周期开始时间
@property (nonatomic, strong)  NSDate  *endDate; // 周期结束时间
@property (nonatomic, strong)  NSMutableArray<MuscleModel *>  *arrayMuscleDate; // <##>
@property (nonatomic, strong)  MuscleModel  *totalData; // 周期内总数据
@end

@implementation DataAnalysisView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

- (void)updateConstraints {
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self);
        make.height.equalTo(self.mas_width).multipliedBy(0.96);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.chartView.mas_bottom);
    }];
    [super updateConstraints];
}
// 设置元素控件
- (void)configElements {
    [self addSubview:self.background];
    [self.background addSubview:self.tableView];
    [self.background addSubview:self.chartView];
    
    // 设置周期数据
    self.beginDate = [DateUtil dateWithComponents:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit date:[NSDate date]];
    [self calPeriodTimeAndSetDataWithIntervalDay:-kPeriodInterval];
    
    [self updateConstraints];
}

#pragma mark - Private Method

// 计算周期起始时间/结束时间
- (void)calPeriodTimeAndSetDataWithIntervalDay:(NSInteger)intervalDay {
    NSDate *beforeCalDate;
    if (intervalDay > 0) {
        // 往后
        beforeCalDate = self.endDate;
        intervalDay -= 1;
    } else {
        // 往前
        beforeCalDate = self.beginDate;
        intervalDay += 1;
    }

    NSDate *caledDate = [DateUtil dateFromDate:beforeCalDate intervalDay:intervalDay];

    if (intervalDay > 0) {
        // 往后
        self.beginDate = beforeCalDate;
        self.endDate = caledDate;
    } else {
        // 往前
        self.beginDate = caledDate;
        self.endDate = beforeCalDate;
    }
    // 如果是今天隐藏右边箭头
    NSDate *todayDate = [DateUtil dateWithComponents:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit date:[NSDate date]];
    if ([self.endDate isEqualToDate:todayDate]) {
        // 防止取不到今天的数据，数据库里训练Date为当前时间，带有分，秒
        self.endDate = [NSDate date];
        [self.periodSelectView hideLeftArrow:NO rightArrow:YES];
    } else {
        [self.periodSelectView hideLeftArrow:NO rightArrow:NO];
    }

    // 计算的日期
    NSString *strBeginDate = [DateUtil stringDateWithDate:self.beginDate dateFormat:kDateFormat];
    NSString *strEndDate = [DateUtil stringDateWithDate:self.endDate dateFormat:kDateFormat];
    [self.periodSelectView setPeriodTitle:[NSString stringWithFormat:@"%@ ~ %@",strBeginDate,strEndDate]];
    
    // 数据库取出数据
    [self.arrayMuscleDate removeAllObjects];
    NSArray *arrayTemp = [[DBUnifiedManager share] fetchAllMuscleDataFromBeginDate:self.beginDate endDate:self.endDate];
    [self.arrayMuscleDate addObjectsFromArray:arrayTemp];
    self.totalData = [[DBUnifiedManager share] fetchComprehensiveDataFromBeginDate:self.beginDate endDate:self.endDate];
    // 更新列表
    [self.tableView reloadData];
    
    // 设置雷达图数据
    [self.chartView setRadarChartViewData:self.arrayMuscleDate];
}
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMuscleDate.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return height_40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.periodSelectView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AnalysisMuscleDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AnalysisMuscleDataTableViewCell alloc] initWithReuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setCellData:self.arrayMuscleDate[indexPath.row] totalTrainingTimes:self.totalData.trainingTimes.integerValue];
    return cell;
}

#pragma mark - PeriodSelectViewDelegate
- (void)PeriodSelectViewDelegateCallBack_beforeButtonClicked {
    [self calPeriodTimeAndSetDataWithIntervalDay:-kPeriodInterval];
}

- (void)PeriodSelectViewDelegateCallBack_afterButtonClicked {
    [self calPeriodTimeAndSetDataWithIntervalDay:kPeriodInterval];
}
#pragma mark - Init
- (UIImageView *)background {
    if (!_background) {
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shape_analysis_bg"]];
        [_background setUserInteractionEnabled:YES];
    }
    return _background;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
            [_tableView setSeparatorColor:[UIColor lineDarkGray_4e4e4e]];
        }
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}

- (PeriodSelectView *)periodSelectView {
    if (!_periodSelectView) {
        _periodSelectView = [[PeriodSelectView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height_40)];
        [_periodSelectView setDelegate:self];
    }
    return _periodSelectView;
}

- (RadarChartView *)chartView {
    if (!_chartView) {
        _chartView = [[RadarChartView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.96)];
    }
    return _chartView;
}

- (NSMutableArray<MuscleModel *> *)arrayMuscleDate {
    if (!_arrayMuscleDate) {
        _arrayMuscleDate = [[NSMutableArray alloc] init];
    }
    return _arrayMuscleDate;
}
@end
