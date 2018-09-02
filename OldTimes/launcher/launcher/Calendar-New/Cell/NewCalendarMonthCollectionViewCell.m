//
//  NewCalendarMonthCollectionViewCell.m
//  launcher
//
//  Created by kylehe on 16/3/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMonthCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "NewMonthPopTableViewCell.h"
#import "MyDefine.h"
#import "NewCalendarWeeksListModel.h"
#import "NewCalendarWeeksModel.h"

@interface NewCalendarMonthCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  日期
 */
@property(nonatomic, strong) UILabel  *titleLabel;
/**
 *  列表
 */
@property(nonatomic, strong) UITableView  *tableview;

@property(nonatomic, strong) UIButton  *monthEventBtn;
@property(nonatomic, strong) UIButton  *monthMeetingBtn;

@property (nonatomic,strong) UIView * line1;
@property (nonatomic,strong) UIView * line2;
@property (nonatomic,strong) UIView * line3;

@property (nonatomic,strong) NewCalendarWeeksListModel *listModel ;

@end

@implementation NewCalendarMonthCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self creatFrame];
    }
    return self;
}

- (void)setCellData:(NewCalendarWeeksListModel *)model
{
    self.listModel = model;
    self.titleLabel.text = [model strDate];
    [self.tableview reloadData];
}

- (void)setHidenBottomViewsWhileIsReadOnly:(BOOL)readOnly {
	self.monthEventBtn.hidden = readOnly;
	self.monthMeetingBtn.hidden = readOnly;
	self.line2.hidden = readOnly;
	self.line3.hidden = readOnly;
}

#pragma makr - privateMethod
- (void)creatFrame
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tableview];
    [self.contentView addSubview:self.monthEventBtn];
    [self.contentView addSubview:self.monthMeetingBtn];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    [self.contentView addSubview:self.line3];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.height.equalTo(@45);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.contentView).offset(45);
        make.height.equalTo(@0.5);
    }];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableview.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.monthEventBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.line2.mas_bottom);
        make.right.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView);
    }];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom);
        make.left.equalTo(self.monthEventBtn.mas_right);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(@0.5);
    }];
    [self.monthMeetingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom);
        make.left.equalTo(self.line3.mas_right);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModel.calendarArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"cell";
    NewMonthPopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NewMonthPopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    [cell setCellData:self.listModel.calendarArray[indexPath.row]];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; };
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01; };
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 高度不定
    NewCalendarWeeksModel * model = [self.listModel.calendarArray objectAtIndex:indexPath.row];
    float height = 55;
    if (model.place.length >0) { // 有地点
        height += 20;
    }
    return height;
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(newCalendarMonthCollectionViewCell_SelectCalendarWithPath:)]) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:indexPath.row inSection:self.indexPath.row];
        [_delegate newCalendarMonthCollectionViewCell_SelectCalendarWithPath:path];
    }
}

#pragma mark - click
- (void)monthEventBtnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(newCalendarMonthCollectionViewCell_pushCreatCalendarVCWithIsMetting:date:)]) {
        [_delegate newCalendarMonthCollectionViewCell_pushCreatCalendarVCWithIsMetting:NO date:self.listModel.srartTime];
    }
}
- (void)monthMeetingBtnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(newCalendarMonthCollectionViewCell_pushCreatCalendarVCWithIsMetting:date:)]) {
        [_delegate newCalendarMonthCollectionViewCell_pushCreatCalendarVCWithIsMetting:YES date:nil];
    }
}

#pragma mark - setterAndGetter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

- (UIButton *)monthEventBtn
{
    if (!_monthEventBtn) {
        _monthEventBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_monthEventBtn setImage:[UIImage imageNamed:@"NewCalendar_Event"] forState:UIControlStateNormal];
        [_monthEventBtn setTitle:[NSString stringWithFormat:@" %@",LOCAL(CALENDAR_ADD_ADDORDER)] forState:UIControlStateNormal];
        [_monthEventBtn addTarget:self action:@selector(monthEventBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_monthEventBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_monthEventBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _monthEventBtn;
}

- (UIButton *)monthMeetingBtn
{
    if (!_monthMeetingBtn) {
        _monthMeetingBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_monthMeetingBtn setImage:[UIImage imageNamed:@"NewCalendar_Meeting"] forState:UIControlStateNormal];
        [_monthMeetingBtn setTitle:[NSString stringWithFormat:@" %@",LOCAL(MEETING_ADDNEWMEETING)] forState:UIControlStateNormal];
        [_monthMeetingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_monthMeetingBtn addTarget:self action:@selector(monthMeetingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_monthMeetingBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _monthMeetingBtn;
}
- (UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1];
    }
    return _line1;
}
- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1];
    }
    return _line2;
}
- (UIView *)line3
{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1];
    }
    return _line3;
}

@end
