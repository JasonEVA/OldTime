//
//  WeightRecordViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "WeightRecordViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "WeightChartView.h"
#import "PeriodSelectView.h"
#import "DateUtil.h"
#import "WeightModel.h"
#import "DBUnifiedManager.h"
#import "Weight.h"
#import "AddWeightViewController.h"
#import "BaseNavigationViewController.h"

static NSInteger const kPeriodInterval = 7;
static NSString *const kDateFormat = @"YYYY.MM.dd";
static NSString *const kShortDateFormat = @"MM-dd";

@interface WeightRecordViewController ()<UITableViewDelegate,UITableViewDataSource,PeriodSelectViewDelegate>
@property (nonatomic, strong)  WeightChartView  *chartView; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  PeriodSelectView  *periodSelectView; // <##>
@property (nonatomic, strong)  NSDate  *beginDate; // 周期开始时间
@property (nonatomic, strong)  NSDate  *endDate; // 周期结束时间
@property (nonatomic, strong)  NSMutableArray<Weight *>  *arrayWeightDate; // <##>

@end

@implementation WeightRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"体重"];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWeight)];
    [self.navigationItem setRightBarButtonItem:addItem];
    [self configElements];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置当前周期数据
    self.beginDate = [DateUtil dateWithComponents:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit date:[NSDate date]];
    [self calPeriodTimeAndSetDataWithIntervalDay:-kPeriodInterval];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
 
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.7);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.chartView.mas_bottom);
    }];
    [super updateViewConstraints];
}
#pragma mark - Private Method
// 添加体重
- (void)addWeight {
    AddWeightViewController *addWeightVC = [[AddWeightViewController alloc] init];
    BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:addWeightVC];
    [self presentViewController:navi animated:YES completion:nil];
}
// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.chartView];
    [self.view addSubview:self.tableView];
    
    
    [self.view needsUpdateConstraints];
}

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
    [self.arrayWeightDate removeAllObjects];
    NSArray *arrayTemp = [[DBUnifiedManager share] fetchWeightDataFromBeginDate:self.beginDate endDate:self.endDate];
    [self.arrayWeightDate addObjectsFromArray:arrayTemp];
    // 更新列表
    [self.tableView reloadData];
    
    // 设置图表数据
    [self getThisWeekDate];
}
// 获得本周事件
- (void)getThisWeekDate {
    
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:kPeriodInterval];
    for (NSInteger i = -6; i <= 0; i ++) {
        NSDate *date = [DateUtil dateFromDate:self.endDate intervalDay:i ];
        NSDateComponents *compTemp = [DateUtil dateComponentsForDate:date];
        [arrayTemp addObject:compTemp];

    }
    [self.chartView setChartDateComponents:arrayTemp weightData:self.arrayWeightDate];
    
}
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayWeightDate.count;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    }
    Weight *weight = self.arrayWeightDate[indexPath.row];
    WeightModel *model = [[WeightModel alloc] initWithEntity:weight];
    NSString *strDate = [DateUtil stringDateWithDate:model.timeStamp dateFormat:kShortDateFormat];
    [cell.textLabel setText:strDate];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.1f",model.weight.floatValue]];
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
- (WeightChartView *)chartView {
    if (!_chartView) {
        _chartView = [[WeightChartView alloc] init];
        [_chartView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];

    }
    return _chartView;
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
        _periodSelectView = [[PeriodSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height_40)];
        [_periodSelectView setDelegate:self];
    }
    return _periodSelectView;
}

- (NSMutableArray<Weight *> *)arrayWeightDate {
    if (!_arrayWeightDate) {
        _arrayWeightDate = [NSMutableArray array];
    }
    return _arrayWeightDate;
}
@end
