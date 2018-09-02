//
//  TeamClassView.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 团课view

#import "TeamClassView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "WeekColumnView.h"
#import "TeamClassTableViewCell.h"
#import "TeamClassModel.h"

@interface TeamClassView()<UITableViewDataSource,UITableViewDelegate,WeekColumnViewDelegate>

@property (nonatomic, strong)  WeekColumnView  *calendarView; // 日期控件
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  NSMutableArray  *array; // <##>
@end
@implementation TeamClassView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [self addSubview:self.tableView];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.calendarView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return height_49;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    TeamClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TeamClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [cell setClassData:self.array[indexPath.row]];
    }
    return cell;
}

#pragma mark - WeekColumnViewDelegate
- (void)WeekColumnViewDelegateCallBack_weekDayClicked:(NSInteger)weekDay {
    [self.tableView reloadData];
}

#pragma mark - Init
- (WeekColumnView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[WeekColumnView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80)];
        [_calendarView setDelegate:self];
    }
    return _calendarView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_tableView setSeparatorColor:[UIColor lineDarkGray_4e4e4e]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];

        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
        NSArray *temp = @[@"人鱼马甲",@"有氧塑形",@"全身雕塑",@"燃脂踏板",@"南美热舞",@"纤体瑜伽"];
        for (NSInteger i = 0; i < 5; i ++) {
            TeamClassModel *model = [[TeamClassModel alloc] initWithTestState:i % 3 name:temp[i % 5] startTime:[NSString stringWithFormat:@"%ld:00",12 + i * 2] endTime:[NSString stringWithFormat:@"%ld:00",14 + i * 2]];
            [_array addObject:model];
        }
    }
    return _array;
}
@end
